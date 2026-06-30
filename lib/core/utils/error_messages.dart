import 'dart:async';

import 'package:dartus/dartus.dart';
import 'package:fluffy_link/services/walrus_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ErrorMessages {
  ErrorMessages._();

  static String forUpload(Object error) {
    if (error is WalrusUploadException) {
      return error.message;
    }
    if (error is PostgrestException) {
      final message = error.message.toLowerCase();
      if (message.contains('upload_limit_exceeded')) {
        return "You've reached the upload limit (7 uploads per day). Please try again later.";
      }
      if (message.contains('not authenticated') ||
          message.contains('not_authenticated') ||
          message.contains('must be signed in')) {
        return 'Please sign in before uploading a file.';
      }
      return "We couldn't save your link. Please try again.";
    }
    if (error is TimeoutException || _isNetworkError(error)) {
      return "We couldn't upload your file. Check your connection and try again.";
    }
    if (error is RetryableWalrusClientError || error is WalrusApiError) {
      return 'Storage service unavailable. Try again in a moment.';
    }
    return "We couldn't upload your file. Please try again.";
  }

  static String forRedirect(Object error) {
    if (error is PostgrestException) {
      return 'Failed to resolve this link. Try again.';
    }
    if (error is TimeoutException || _isNetworkError(error)) {
      return 'Check your connection and try again.';
    }
    return 'Something went wrong. Try again.';
  }

  static bool _isNetworkError(Object error) {
    final type = error.runtimeType.toString();
    return type.contains('SocketException') ||
        type.contains('ClientException') ||
        type.contains('NetworkException');
  }
}
