import 'dart:typed_data';
import 'package:dartus/dartus.dart';
import 'package:fluffy_link/core/constants.dart';

class WalrusUploadException implements Exception {
  const WalrusUploadException(this.message);
  final String message;
  @override
  String toString() => message;
}

class WalrusService {
  late final WalrusClient _client;

  WalrusService() {
    _client = WalrusClient(
      publisherBaseUrl: Uri.parse(AppConstants.walrusPublisher),
      aggregatorBaseUrl: Uri.parse(AppConstants.walrusAggregator),
      useSecureConnection: false,
      logLevel: WalrusLogLevel.warning,
    );
  }

  Future<String> uploadBlob(List<int> bytes, {int retries = 2}) async {
    if (bytes.isEmpty) {
      throw const WalrusUploadException('Cannot upload an empty file.');
    }

    for (var attempt = 0; attempt <= retries; attempt++) {
      try {
        final response = await _client.putBlob(
          data: Uint8List.fromList(bytes),
          epochs: AppConstants.storageEpochs,
        );
        return extractBlobId(response);
      } catch (e) {
        if (attempt == retries) {
          throw WalrusUploadException(e.toString());
        }
        await Future<void>.delayed(Duration(seconds: attempt + 1));
      }
    }

    throw const WalrusUploadException(
      'Storage service unavailable. Try again in a moment.',
    );
  }

  static String extractBlobId(Map<String, dynamic> response) {
    final newlyCreated = response['newlyCreated'];
    if (newlyCreated is Map<String, dynamic>) {
      final blobObject = newlyCreated['blobObject'];
      if (blobObject is Map<String, dynamic>) {
        final blobId = blobObject['blobId'];
        if (blobId is String && blobId.isNotEmpty) return blobId;
      }
    }

    final alreadyCertified = response['alreadyCertified'];
    if (alreadyCertified is Map<String, dynamic>) {
      final blobId = alreadyCertified['blobId'];
      if (blobId is String && blobId.isNotEmpty) return blobId;
    }

    throw const WalrusUploadException(
      'Upload succeeded but no blob ID was returned.',
    );
  }

  Future<void> dispose() async => _client.close();
}
