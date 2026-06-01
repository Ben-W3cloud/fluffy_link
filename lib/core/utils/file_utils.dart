class FileUtils {
  const FileUtils._();

  static String formatBytes(int bytes) {
    if (bytes < 0) {
      throw ArgumentError.value(bytes, 'bytes', 'Must not be negative.');
    }
    if (bytes < 1024) return '$bytes B';

    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';

    final mb = kb / 1024;
    if (mb < 1024) return '${mb.toStringAsFixed(1)} MB';

    final gb = mb / 1024;
    return '${gb.toStringAsFixed(1)} GB';
  }
}
