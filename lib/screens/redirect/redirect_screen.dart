import 'package:fluffy_link/services/link_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class RedirectScreen extends StatefulWidget {
  const RedirectScreen({
    super.key,
    required this.code,
    LinkService? linkService,
  }) : _linkService = linkService;

  final String code;
  final LinkService? _linkService;

  @override
  State<RedirectScreen> createState() => _RedirectScreenState();
}

class _RedirectScreenState extends State<RedirectScreen> {
  late final LinkService _links = widget._linkService ?? LinkService();

  bool _notFound = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _resolve();
  }

  Future<void> _resolve() async {
    try {
      final link = await _links.resolveAndTrack(widget.code);
      if (!mounted) return;

      if (link == null) {
        setState(() => _notFound = true);
        return;
      }

      final uri = Uri.parse(link.walrusUrl);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        setState(() => _errorMessage = 'Could not open the stored file.');
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_notFound) {
      return const _RedirectMessage(
        title: '404 - Link not found',
        actionLabel: 'Go home',
      );
    }

    final error = _errorMessage;
    if (error != null) {
      return _RedirectMessage(
        title: 'Redirect failed',
        message: error,
        actionLabel: 'Go home',
      );
    }

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class _RedirectMessage extends StatelessWidget {
  const _RedirectMessage({
    required this.title,
    required this.actionLabel,
    this.message,
  });

  final String title;
  final String? message;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              if (message != null) ...[
                const SizedBox(height: 12),
                Text(message!, textAlign: TextAlign.center),
              ],
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/'),
                child: Text(actionLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
