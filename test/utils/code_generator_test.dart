import 'package:fluffy_link/core/constants.dart';
import 'package:fluffy_link/core/utils/code_generator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generates a default-length lowercase short code', () {
    final code = CodeGenerator.generate();

    expect(code, hasLength(AppConstants.shortCodeLength));
    expect(RegExp(r'^[a-z0-9]+$').hasMatch(code), isTrue);
  });

  test('generates a requested length', () {
    expect(CodeGenerator.generate(length: 12), hasLength(12));
  });

  test('rejects non-positive lengths', () {
    expect(() => CodeGenerator.generate(length: 0), throwsArgumentError);
  });
}
