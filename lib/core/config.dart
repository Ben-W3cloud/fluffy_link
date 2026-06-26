// lib/config.dart
class AppConfig {
  static const String apiKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'development-key-fallback',
  );

  static const String apiUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://api.dev.example.com',
  );
}
