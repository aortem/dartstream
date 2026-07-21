import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:test/test.dart';

import '../lib/commands/ds_login_command.dart';

const validCliToken = 'secret_0123456789abcdef0123456789abcdef';

void main() {
  test('login --token saves DartStream CLI credentials', () async {
    final tempDir = Directory.systemTemp.createTempSync(
      'dartstream_login_test_',
    );
    addTearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    final runner = CommandRunner<void>('dartstream', 'test runner')
      ..addCommand(DSLoginCommand(configDirectory: tempDir));

    await runner.run([
      'login',
      '--token',
      validCliToken,
      '--api-url',
      'https://dev-api.dartstream.io',
    ]);

    final credentialsFile = File(
      '${tempDir.path}${Platform.pathSeparator}credentials.json',
    );
    expect(credentialsFile.existsSync(), isTrue);

    final credentials =
        jsonDecode(credentialsFile.readAsStringSync()) as Map<String, dynamic>;
    expect(credentials['token'], validCliToken);
    expect(credentials['apiUrl'], 'https://dev-api.dartstream.io');
    expect(credentials['savedAt'], isA<String>());
  });

  test('login requires a token', () async {
    final runner = CommandRunner<void>('dartstream', 'test runner')
      ..addCommand(DSLoginCommand(configDirectory: Directory.systemTemp));

    await expectLater(
      () => runner.run(['login']),
      throwsA(isA<UsageException>()),
    );
  });

  test('login rejects malformed tokens before saving credentials', () async {
    final tempDir = Directory.systemTemp.createTempSync(
      'dartstream_invalid_login_test_',
    );
    addTearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    final runner = CommandRunner<void>('dartstream', 'test runner')
      ..addCommand(DSLoginCommand(configDirectory: tempDir));

    await expectLater(
      () => runner.run(['login', '--token', 'dummyToken23232']),
      throwsA(isA<UsageException>()),
    );

    expect(
      File(
        '${tempDir.path}${Platform.pathSeparator}credentials.json',
      ).existsSync(),
      isFalse,
    );
  });
}
