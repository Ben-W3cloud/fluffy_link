import 'package:fluffy_link/core/theme.dart';
import 'package:fluffy_link/screens/auth/auth_screen.dart';
import 'package:fluffy_link/screens/dashboard/dashboard_screen.dart';
import 'package:fluffy_link/screens/file/file_page_screen.dart';
import 'package:fluffy_link/screens/home/home_screen.dart';
import 'package:fluffy_link/screens/landing/landing_screen.dart';
import 'package:fluffy_link/screens/stats/stats_screen.dart';
import 'package:fluffy_link/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter createRouter(AuthService authService) => GoRouter(
  refreshListenable: authService,
  redirect: (context, state) {
    if (!authService.isInitialized) return null;

    final path = state.uri.path;
    final isAuthRoute = path == '/auth';
    final isProtected = path == '/upload' || path == '/dashboard';

    if (isProtected && !authService.isAuthenticated) {
      final from = Uri.encodeComponent(state.uri.toString());
      return '/auth?redirect=$from';
    }

    if (isAuthRoute && authService.isAuthenticated) {
      final redirect = state.uri.queryParameters['redirect'];
      if (redirect != null && redirect.isNotEmpty) {
        return Uri.decodeComponent(redirect);
      }
      return '/dashboard';
    }

    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      path: '/s/:code',
      builder: (context, state) {
        return StatsScreen(code: state.pathParameters['code']!);
      },
    ),
    GoRoute(path: '/upload', builder: (context, state) => const HomeScreen()),
    GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
    GoRoute(path: '/', builder: (context, state) => const LandingScreen()),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/:code',
      builder: (context, state) {
        final params = state.uri.queryParameters;
        return FilePageScreen(
          code: state.pathParameters['code']!,
          autoDownload: params['download'] == '1',
          autoRaw: params['raw'] == '1',
        );
      },
    ),
  ],
  errorBuilder: (context, state) => const NotFoundScreen(),
);

class PermaLinkApp extends StatefulWidget {
  const PermaLinkApp({super.key});

  @override
  State<PermaLinkApp> createState() => _PermaLinkAppState();
}

class _PermaLinkAppState extends State<PermaLinkApp> {
  late final AuthService _authService = AuthService();
  late final GoRouter _router = createRouter(_authService);
  bool _authReady = false;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    await _authService.initialize();
    if (!mounted) return;
    setState(() => _authReady = true);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScope(
      authService: _authService,
      child: MaterialApp.router(
        title: 'Perma.link',
        theme: AppTheme.dark,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          if (!_authReady) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.link_off_rounded,
              size: 48,
              color: AppTheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Link not found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              "This link doesn't exist or may have expired.",
              style: TextStyle(color: AppTheme.muted),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Go to Perma.link'),
            ),
          ],
        ),
      ),
    );
  }
}
