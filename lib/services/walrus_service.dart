import 'dart:typed_data';

import 'package:dartus/dartus.dart';
import 'package:fluffy_link/core/constants.dart';

class WalrusService {
  WalrusService({WalrusClient? client}) : _client = client ?? _createClient();

  final WalrusClient _client;

  static WalrusClient _createClient() {
    return WalrusClient(
      publisherBaseUrl: Uri.parse(AppConstants.walrusPublisher),
      aggregatorBaseUrl: Uri.parse(AppConstants.walrusAggregator),
      useSecureConnection: false,
      logLevel: WalrusLogLevel.warning,
    );
  }

  /// Uploads bytes to Walrus and returns the certified blob ID.
  Future<String> uploadBlob(List<int> bytes, {int retries = 2}) async {
    if (bytes.isEmpty) {
      throw ArgumentError.value(bytes, 'bytes', 'Cannot upload an empty file.');
    }

    for (var attempt = 0; attempt <= retries; attempt++) {
      try {
        return await _doUpload(bytes);
      } on RetryableWalrusClientError {
        // README mentions _client.reset(), but Dartus 0.2.0 does not expose it.
        // Backoff and retry the HTTP upload instead.
        if (attempt == retries) rethrow;
        await Future<void>.delayed(Duration(seconds: attempt + 1));
      } on WalrusApiError catch (error) {
        if (!_isRetryableApiError(error) || attempt == retries) rethrow;
        await Future<void>.delayed(Duration(seconds: attempt + 1));
      }
    }

    throw StateError('Upload failed after $retries retries.');
  }

  Future<String> _doUpload(List<int> bytes) async {
    final response = await _client.putBlob(
      // Dartus 0.2.0 requires Uint8List even though the README uses List<int>.
      data: Uint8List.fromList(bytes),
      epochs: AppConstants.storageEpochs,
    );
    return extractBlobId(response);
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

    throw const FormatException('Walrus upload returned no blobId.');
  }

  // close() is async in Dartus 0.2.0; callers can fire-and-forget from dispose.
  Future<void> dispose() => _client.close();

  bool _isRetryableApiError(WalrusApiError error) {
    return error.code == 429 || error.code >= 500;
  }
}
