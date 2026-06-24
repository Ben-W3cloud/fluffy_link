import 'dart:typed_data';
import 'dart:developer' as developer;
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
    developer.log('Initializing WalrusClient', name: 'WalrusService');
    _client = WalrusClient(
      publisherBaseUrl: Uri.parse(AppConstants.walrusPublisher),
      aggregatorBaseUrl: Uri.parse(AppConstants.walrusAggregator),
      useSecureConnection: false,
      logLevel: WalrusLogLevel.warning,
    );
    developer.log('WalrusClient initialized', name: 'WalrusService');
  }

  Future<String> uploadBlob(List<int> bytes, {int retries = 2}) async {
    if (bytes.isEmpty) {
      developer.log(
        'uploadBlob called with empty bytes',
        name: 'WalrusService.uploadBlob',
      );
      throw const WalrusUploadException('Cannot upload an empty file.');
    }
    developer.log(
      'Beginning uploadBlob',
      name: 'WalrusService.uploadBlob',
      error: {'bytes': bytes.length, 'retries': retries},
    );

    for (var attempt = 0; attempt <= retries; attempt++) {
      developer.log(
        'Upload attempt start',
        name: 'WalrusService.uploadBlob',
        error: {'attempt': attempt + 1},
      );
      try {
        final response = await _client.putBlob(
          data: Uint8List.fromList(bytes),
          epochs: AppConstants.storageEpochs,
        );
        developer.log(
          'PutBlob response received',
          name: 'WalrusService.uploadBlob',
          error: response,
        );
        final blobId = extractBlobId(response);
        developer.log(
          'Extracted blobId',
          name: 'WalrusService.uploadBlob',
          error: blobId,
        );
        return blobId;
      } catch (e, st) {
        developer.log(
          'Upload attempt failed',
          name: 'WalrusService.uploadBlob',
          error: e,
          stackTrace: st,
        );
        if (attempt == retries) {
          developer.log(
            'All attempts exhausted; rethrowing',
            name: 'WalrusService.uploadBlob',
            error: e,
          );
          throw WalrusUploadException(e.toString());
        }
        await Future<void>.delayed(Duration(seconds: attempt + 1));
      }
    }

    developer.log(
      'Reached unexpected end of uploadBlob',
      name: 'WalrusService.uploadBlob',
    );
    throw const WalrusUploadException(
      'Storage service unavailable. Try again in a moment.',
    );
  }

  static String extractBlobId(Map<String, dynamic> response) {
    developer.log(
      'extractBlobId start',
      name: 'WalrusService.extractBlobId',
      error: response,
    );

    final newlyCreated = response['newlyCreated'];
    if (newlyCreated is Map<String, dynamic>) {
      developer.log(
        'Response has newlyCreated',
        name: 'WalrusService.extractBlobId',
        error: newlyCreated,
      );
      final blobObject = newlyCreated['blobObject'];
      if (blobObject is Map<String, dynamic>) {
        final blobId = blobObject['blobId'];
        developer.log(
          'Found blobObject',
          name: 'WalrusService.extractBlobId',
          error: blobObject,
        );
        if (blobId is String && blobId.isNotEmpty) {
          developer.log(
            'Returning blobId from newlyCreated',
            name: 'WalrusService.extractBlobId',
            error: blobId,
          );
          return blobId;
        }
      }
    }

    final alreadyCertified = response['alreadyCertified'];
    if (alreadyCertified is Map<String, dynamic>) {
      developer.log(
        'Response has alreadyCertified',
        name: 'WalrusService.extractBlobId',
        error: alreadyCertified,
      );
      final blobId = alreadyCertified['blobId'];
      if (blobId is String && blobId.isNotEmpty) {
        developer.log(
          'Returning blobId from alreadyCertified',
          name: 'WalrusService.extractBlobId',
          error: blobId,
        );
        return blobId;
      }
    }

    developer.log(
      'No blob id found in response',
      name: 'WalrusService.extractBlobId',
      error: response,
    );
    throw const WalrusUploadException(
      'Upload succeeded but no blob ID was returned.',
    );
  }

  Future<void> dispose() async => _client.close();
}
