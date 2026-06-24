import 'dart:ui';
import 'package:fluffy_link/app.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    print('FLUTTER ERROR: ${details.exception}');
    print('FLUTTER ERROR TYPE: ${details.exception.runtimeType}');
    print('STACK: ${details.stack}');
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    print('PLATFORM ERROR: $error');
    print('PLATFORM ERROR TYPE: ${error.runtimeType}');
    print('STACK: $stack');
    return true;
  };

  await _initializeSupabase();
  runApp(const PermaLinkApp());
}

Future<void> _initializeSupabase() async {
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw Exception(
      'Missing SUPABASE_URL or SUPABASE_ANON_KEY. '
      'Pass them via --dart-define at build time.',
    );
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
}
