import 'dart:async';

import 'package:fluffy_link/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum SignUpStatus { signedIn, confirmationEmailSent }

class AuthService with ChangeNotifier {
  AuthService({SupabaseClient? client}) : _client = client;

  final SupabaseClient? _client;

  SupabaseClient get _supabase => _client ?? Supabase.instance.client;

  Session? _currentSession;
  StreamSubscription<AuthState>? _authSubscription;
  bool _initialized = false;

  Session? get currentSession => _currentSession;
  User? get currentUser => _currentSession?.user;
  bool get isInitialized => _initialized;
  bool get isAuthenticated => _currentSession?.user != null;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      _currentSession = _supabase.auth.currentSession;
      _authSubscription = _supabase.auth.onAuthStateChange.listen((authState) {
        _setSession(authState.session);
      });
    } catch (e) {
      debugPrint('AuthService.initialize skipped: $e');
    }
    _initialized = true;
    notifyListeners();
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      _setSession(response.session);
    } catch (e) {
      debugPrint('Error signing in: $e');
      rethrow;
    }
  }

  Future<SignUpStatus> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: '${AppConstants.appDomain}/dashboard',
      );
      if (response.session != null) {
        _setSession(response.session);
        return SignUpStatus.signedIn;
      }

      return SignUpStatus.confirmationEmailSent;
    } catch (e) {
      debugPrint('Error signing up: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      _setSession(null);
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  void _setSession(Session? session) {
    final previousUserId = _currentSession?.user.id;
    final previousToken = _currentSession?.accessToken;
    _currentSession = session;
    if (previousUserId != session?.user.id ||
        previousToken != session?.accessToken) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

class AuthScope extends InheritedNotifier<AuthService> {
  const AuthScope({
    super.key,
    required AuthService authService,
    required super.child,
  }) : super(notifier: authService);

  static AuthService of(BuildContext context) {
    final authScope = context.dependOnInheritedWidgetOfExactType<AuthScope>();
    if (authScope == null) {
      throw FlutterError('AuthScope not found in context');
    }
    return authScope.notifier!;
  }
}
