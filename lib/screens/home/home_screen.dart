import 'package:file_picker/file_picker.dart';
import 'package:fluffy_link/core/constants.dart';
import 'package:fluffy_link/models/link_model.dart';
import 'package:fluffy_link/screens/home/widgets/drop_zone.dart';
import 'package:fluffy_link/screens/home/widgets/success_card.dart';
import 'package:fluffy_link/screens/home/widgets/upload_progress.dart';
import 'package:fluffy_link/services/link_service.dart';
import 'package:fluffy_link/services/walrus_service.dart';
import 'package:flutter/material.dart';

enum UploadState { idle, uploading, done, error }

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    WalrusService? walrusService,
    LinkService? linkService,
  }) : _walrusService = walrusService,
       _linkService = linkService;

  // Optional service injection keeps the README UI testable without live
  // Walrus or Supabase calls.
  final WalrusService? _walrusService;
  final LinkService? _linkService;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WalrusService _walrus = widget._walrusService ?? WalrusService();
  late final LinkService _links = widget._linkService ?? LinkService();

  UploadState _state = UploadState.idle;
  String? _errorMessage;
  LinkModel? _createdLink;

  Future<void> _handleFilePick() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result == null || result.files.isEmpty) return;

    await _upload(result.files.first);
  }

  Future<void> _upload(PlatformFile file) async {
    final bytes = file.bytes;
    if (bytes == null) {
      _showError('Could not read the selected file.');
      return;
    }

    if (file.size > AppConstants.maxUploadBytes) {
      // README polish step: enforce the local upload limit before network work.
      _showError('File must be under 10 MB.');
      return;
    }

    setState(() {
      _state = UploadState.uploading;
      _errorMessage = null;
    });

    try {
      final blobId = await _walrus.uploadBlob(bytes);
      final link = await _links.createLink(
        blobId: blobId,
        fileName: file.name,
        fileSize: file.size,
      );

      if (!mounted) return;
      setState(() {
        _state = UploadState.done;
        _createdLink = link;
      });
    } catch (error) {
      if (!mounted) return;
      _showError(error.toString());
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
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: switch (_state) {
                UploadState.idle || UploadState.error => _UploadPicker(
                  errorMessage: _errorMessage,
                  onBrowse: _handleFilePick,
                  onFileDrop: _upload,
                ),
                UploadState.uploading => const UploadProgress(),
                UploadState.done => SuccessCard(
                  link: _createdLink!,
                  onReset: _reset,
                ),
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Flutter dispose cannot be async, so close the Walrus client in the
    // background after this widget is removed.
    _walrus.dispose().ignore();
    super.dispose();
  }
}

class _UploadPicker extends StatelessWidget {
  const _UploadPicker({
    required this.errorMessage,
    required this.onBrowse,
    required this.onFileDrop,
  });

  final String? errorMessage;
  final VoidCallback onBrowse;
  final Future<void> Function(PlatformFile file) onFileDrop;

  @override
  Widget build(BuildContext context) {
    final error = errorMessage;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const _Logo(),
        const SizedBox(height: 40),
        DropZone(onFileDrop: onFileDrop),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: onBrowse,
          icon: const Icon(Icons.folder_open_outlined),
          label: const Text('Browse files'),
        ),
        if (error != null) ...[
          const SizedBox(height: 16),
          Text(
            error,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            textAlign: TextAlign.center,
          ),
        ],
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
        Icon(
          Icons.link_rounded,
          size: 48,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 12),
        Text('Perma.link', style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}
