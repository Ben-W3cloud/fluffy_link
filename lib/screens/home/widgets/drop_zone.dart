import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class DropZone extends StatefulWidget {
  const DropZone({super.key, required this.onFileDrop});

  final Future<void> Function(PlatformFile file) onFileDrop;

  @override
  State<DropZone> createState() => _DropZoneState();
}

class _DropZoneState extends State<DropZone> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // This mirrors the README visual drop zone. Actual file bytes still come
    // from file_picker because Flutter Web drag-drop support varies by version.
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _hovered
              ? colorScheme.primaryContainer
              : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? colorScheme.primary : colorScheme.outline,
            width: 1.5,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.upload_file_outlined, size: 40),
              SizedBox(height: 12),
              Text('Drop your file here'),
            ],
          ),
        ),
      ),
    );
  }
}
