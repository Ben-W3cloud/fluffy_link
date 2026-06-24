import 'package:fluffy_link/core/theme.dart';
import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.surface,
                border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.15),
                ),
                boxShadow: AppTheme.glowShadow(opacity: 0.1, blur: 20),
              ),
              child: const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(color: AppTheme.muted, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
