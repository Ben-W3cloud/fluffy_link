import 'package:fluffy_link/models/link_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SuccessCard extends StatefulWidget {
  const SuccessCard({super.key, required this.link, required this.onReset});

  final LinkModel link;
  final VoidCallback onReset;

  @override
  State<SuccessCard> createState() => _SuccessCardState();
}

class _SuccessCardState extends State<SuccessCard> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.link.shortUrl));
    setState(() => _copied = true);

    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_outline, color: Colors.green, size: 48),
        const SizedBox(height: 16),
        Text('Your link is ready', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.link.shortUrl,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(_copied ? Icons.check : Icons.copy_outlined),
                tooltip: _copied ? 'Copied' : 'Copy link',
                onPressed: _copy,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        TextButton.icon(
          onPressed: widget.onReset,
          icon: const Icon(Icons.upload_file_outlined),
          label: const Text('Upload another file'),
        ),
      ],
    );
  }
}
