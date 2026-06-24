import 'package:file_picker/file_picker.dart';
import 'package:fluffy_link/core/constants.dart';
import 'package:fluffy_link/core/page_scaffold.dart';
import 'package:fluffy_link/core/theme.dart';
import 'package:fluffy_link/core/utils/error_messages.dart';
import 'package:fluffy_link/core/utils/file_utils.dart';
import 'package:fluffy_link/models/link_model.dart';
import 'package:fluffy_link/screens/home/widgets/drop_zone.dart';
import 'package:fluffy_link/screens/home/widgets/error_card.dart';
import 'package:fluffy_link/screens/home/widgets/success_card.dart';
import 'package:fluffy_link/screens/home/widgets/upload_progress.dart';
import 'package:fluffy_link/services/link_service.dart';
import 'package:fluffy_link/services/walrus_service.dart';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

enum UploadState { idle, uploading, done, error }

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    WalrusService? walrusService,
    LinkService? linkService,
  }) : _walrusService = walrusService,
       _linkService = linkService;

  final WalrusService? _walrusService;
  final LinkService? _linkService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WalrusService _walrus = widget._walrusService ?? WalrusService();
  late final LinkService _links = widget._linkService ?? LinkService();

  UploadState _state = UploadState.idle;
  UploadPhase _phase = UploadPhase.walrus;
  String? _errorMessage;
  LinkModel? _createdLink;
  UploadMetadata? _uploadMetadata;
  String _uploadingFileName = '';

  Future<void> _handleFilePick() async {
    developer.log('Opening file picker', name: 'HomeScreen._handleFilePick');
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result == null || result.files.isEmpty) return;
    developer.log(
      'File selected from picker',
      name: 'HomeScreen._handleFilePick',
      error: {'name': result.files.first.name, 'size': result.files.first.size},
    );
    await _upload(result.files.first);
  }

  Future<void> _upload(PlatformFile file) async {
    final bytes = file.bytes;
    if (bytes == null) {
      developer.log(
        'File bytes null',
        name: 'HomeScreen._upload',
        error: {'file': file.name},
      );
      _showError('Could not read the selected file.');
      return;
    }

    if (file.size > AppConstants.maxFileSizeBytes) {
      developer.log(
        'File too large',
        name: 'HomeScreen._upload',
        error: {'file': file.name, 'size': file.size},
      );
      _showError('File must be under 10MB');
      return;
    }

    setState(() {
      _state = UploadState.uploading;
      _phase = UploadPhase.walrus;
      _errorMessage = null;
      _uploadingFileName = file.name;
    });

    developer.log(
      'Starting upload flow',
      name: 'HomeScreen._upload',
      error: {'file': file.name, 'size': file.size},
    );
    developer.log(
      'Phase set to walrus',
      name: 'HomeScreen._upload',
      error: {'phase': _phase.toString()},
    );
    try {
      developer.log(
        'Calling WalrusService.uploadBlob',
        name: 'HomeScreen._upload',
      );
      final blobId = await _walrus.uploadBlob(bytes);
      developer.log(
        'Walrus.uploadBlob returned',
        name: 'HomeScreen._upload',
        error: {'blobId': blobId},
      );

      if (!mounted) return;
      setState(() => _phase = UploadPhase.saving);
      developer.log(
        'Phase set to saving',
        name: 'HomeScreen._upload',
        error: {'phase': _phase.toString()},
      );

      developer.log(
        'Calling LinkService.createLink',
        name: 'HomeScreen._upload',
        error: {'blobId': blobId},
      );
      final link = await _links.createLink(
        blobId: blobId,
        fileName: file.name,
        fileSize: file.size,
      );
      developer.log(
        'LinkService.createLink returned',
        name: 'HomeScreen._upload',
        error: link.toString(),
      );

      if (!mounted) return;
      setState(() {
        _state = UploadState.done;
        _createdLink = link;
        _uploadMetadata = UploadMetadata(
          fileName: file.name,
          fileSize: file.size,
          mimeType: FileUtils.mimeFromExtension(file.extension),
          uploadedAt: DateTime.now(),
        );
      });
    } catch (error, stack) {
      if (!mounted) return;
      developer.log(
        'Home upload error',
        name: 'HomeScreen._upload',
        error: error,
        stackTrace: stack,
      );
      _showError(ErrorMessages.forUpload(error));
    }
  }

  void _showError(String message) {
    setState(() {
      _state = UploadState.error;
      _errorMessage = message;
    });
  }

  void _reset() {
    setState(() {
      _state = UploadState.idle;
      _createdLink = null;
      _uploadMetadata = null;
      _errorMessage = null;
      _phase = UploadPhase.walrus;
      _uploadingFileName = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      currentRoute: '/upload',
      maxContentWidth: 560,
      scrollable: false,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: switch (_state) {
          UploadState.idle => _UploadPicker(
            onBrowse: _handleFilePick,
            onFileDrop: _upload,
          ),
          UploadState.uploading => UploadProgress(
            fileName: _uploadingFileName,
            phase: _phase,
          ),
          UploadState.done => SuccessCard(
            link: _createdLink!,
            metadata: _uploadMetadata!,
            onReset: _reset,
          ),
          UploadState.error => ErrorCard(
            message: _errorMessage ?? 'Something went wrong. Try again.',
            onRetry: _reset,
          ),
        },
      ),
    );
  }

  @override
  void dispose() {
    _walrus.dispose().ignore();
    super.dispose();
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// UPLOAD PICKER (idle state)
// ═══════════════════════════════════════════════════════════════════════════

class _UploadPicker extends StatelessWidget {
  const _UploadPicker({required this.onBrowse, required this.onFileDrop});

  final VoidCallback onBrowse;
  final Future<void> Function(PlatformFile file) onFileDrop;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _Logo(),
        const SizedBox(height: 16),
        Text(
          'Upload any file. Get a permanent short link. Powered by Walrus.',
          style: TextStyle(color: AppTheme.muted, fontSize: 14, height: 1.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        DropZone(onFileDrop: onFileDrop),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: onBrowse,
          icon: const Icon(Icons.folder_open_outlined),
          label: const Text('Browse files'),
        ),
        const SizedBox(height: 8),
        Text(
          'Any file up to 10MB',
          style: TextStyle(color: AppTheme.mutedDim, fontSize: 13),
        ),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: AppTheme.primaryGradient,
            boxShadow: AppTheme.glowShadow(opacity: 0.35, blur: 28),
          ),
          child: const Icon(Icons.link_rounded, size: 32, color: Colors.white),
        ),
        const SizedBox(height: 20),
        Text(
          'PERMA.LINK',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            fontSize: 38,
          ),
        ),
      ],
    );
  }
}
