import 'package:fluffy_link/core/app_navbar.dart';
import 'package:fluffy_link/core/theme.dart';
import 'package:flutter/material.dart';

/// Shared chrome for every sub-page (about, docs, home, stats). Provides the
/// nav bar, safe area, optional scrolling, and a centered max-width content
/// frame so all pages line up consistently with each other.
class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.currentRoute,
    required this.child,
    this.scrollable = true,
    this.maxContentWidth = AppTheme.maxContentWidth,
    this.centerContent = true,
  });

  final String currentRoute;
  final Widget child;
  final bool scrollable;
  final double maxContentWidth;
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    Widget content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxContentWidth),
      child: child,
    );

    if (centerContent) {
      content = Center(child: content);
    }

    if (scrollable) {
      content = SingleChildScrollView(child: content);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppNavBar(currentRoute: currentRoute),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
