import 'dart:math';

import 'package:fluffy_link/core/constants.dart';

class CodeGenerator {
  CodeGenerator._();

  static const String _chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  static final Random _random = Random.secure();

  static String generate({int length = AppConstants.shortCodeLength}) {
    if (length <= 0) {
      throw ArgumentError.value(length, 'length', 'Must be greater than zero.');
    }

    return List<String>.generate(
      length,
      (_) => _chars[_random.nextInt(_chars.length)],
      growable: false,
    ).join();
  }
}
