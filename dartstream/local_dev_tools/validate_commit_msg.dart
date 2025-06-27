import 'dart:io';

void main(List<String> args) {
  print('Validating commit message...');

  if (args.isEmpty) {
    print('❌ No commit message file provided.');
    exit(1);
  }

  final commitMessage = File(args[0]).readAsStringSync();
  final regex = RegExp(
    r'^(feat|fix|hotfix|chore|test|refactor|release|docs)(\([a-z0-9_-]+\))?: .{1,72}$',
  );

  if (!regex.hasMatch(commitMessage)) {
    print('❌ Commit message does not follow the required format.');
    print('Format: <type>(<scope>): <short summary>');
    print('Examples:');
    print('  feat(auth): add OAuth 2.0 support');
    print('  fix(payment): resolve rounding error');
    exit(1);
  }

  print('✅ Commit message is valid.');
}
