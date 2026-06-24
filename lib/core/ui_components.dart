import 'package:fluffy_link/core/theme.dart';
import 'package:flutter/material.dart';

/// Thin horizontal divider with an optional centered label, used between
/// content groups on About / Docs / Stats. The card and button systems were
/// consolidated into `AppTheme.glassCard()` + the Material theme's `FilledButton`
/// / `OutlinedButton` / `TextButton`; no `CyberCard` / `CyberButton` here.
class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    Widget line() => Expanded(
      child: Container(
        height: 1,
        color: AppTheme.border.withValues(alpha: 0.3),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceLg),
      child: Row(
        children: [
          line(),
          if (label != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd),
              child: Text(
                label!,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.mutedDim,
                  letterSpacing: 1,
                ),
              ),
            ),
            line(),
          ],
        ],
      ),
    );
  }
}
