import 'package:fluffy_link/app.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initializeSupabase();
  runApp(const PermaLinkApp());
}

Future<void> _initializeSupabase() async {
  const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  // README expects real dart-defines; keep local runs/tests usable until they
  // are provided by skipping initialization when either value is missing.
  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    return;
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
}
