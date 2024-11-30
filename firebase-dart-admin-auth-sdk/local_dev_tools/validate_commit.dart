import 'dart:io';

void main(List<String> args) {
  print('Validating commit...');

  // Run dart analyze
  final analyzeResult = Process.runSync('dart', ['analyze']);
  if (analyzeResult.exitCode != 0) {
    print('❌ Dart analyze failed. Please fix the issues.');
    print(analyzeResult.stdout);
    exit(1);
  }

  // Run dart format
  final formatResult =
      Process.runSync('dart', ['format', '--set-exit-if-changed', '.']);
  if (formatResult.exitCode != 0) {
    print('❌ Dart format failed. Please format your code.');
    exit(1);
  }

  print('✅ Commit passed all validations.');
}
