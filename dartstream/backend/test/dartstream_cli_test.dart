import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ds_dartstream/src/cli/dartstream_cli.dart';
import 'package:test/test.dart';

void main() {
  test('public runner exposes the full hosted CLI command set', () {
    final runner = createDartStreamCommandRunner();

    expect(
      runner.commands.keys,
      containsAll([
        'init',
        'configure',
        'setup',
        'generate',
        'validate',
        'extensions',
        'discover',
        'list',
        'enable-extension',
        'disable-extension',
        'login',
      ]),
    );
  });

  test('login --token saves credentials through the hosted runner', () async {
    final tempDir = Directory.systemTemp.createTempSync(
      'dartstream_cli_login_test_',
    );
    addTearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    final runner = createDartStreamCommandRunner(
      workingDirectory: tempDir,
      loginConfigDirectory: tempDir,
    );
    await runner.run([
      'login',
      '--token',
      'qa-token',
      '--api-url',
      'https://dev-api.dartstream.io',
    ]);

    final credentials =
        jsonDecode(
              File(
                '${tempDir.path}${Platform.pathSeparator}credentials.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>;
    expect(credentials['token'], 'qa-token');
    expect(credentials['apiUrl'], 'https://dev-api.dartstream.io');
  });

  test(
    'init, configure, and validate run without workspace packages',
    () async {
      final tempDir = Directory.systemTemp.createTempSync(
        'dartstream_cli_project_test_',
      );
      addTearDown(() {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      });

      final runner = createDartStreamCommandRunner(workingDirectory: tempDir);
      await runner.run(['init', '--name', 'sample_app']);
      await runner.run([
        'configure',
        '--name',
        'sample_app',
        '--vendor',
        'gcp',
        '--auth',
        'firebase',
        '--database',
        'postgres',
        '--cicd',
        'gitlab',
      ]);
      await runner.run(['validate']);

      expect(
        File(
          '${tempDir.path}${Platform.pathSeparator}pubspec.yaml',
        ).existsSync(),
        isTrue,
      );
      expect(
        File(
          '${tempDir.path}${Platform.pathSeparator}dartstream.yaml',
        ).existsSync(),
        isTrue,
      );
    },
  );

  test(
    'generate client creates a standalone package from OpenAPI JSON',
    () async {
      final tempDir = Directory.systemTemp.createTempSync(
        'dartstream_cli_generate_test_',
      );
      addTearDown(() {
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      });

      final specFile = File(
        '${tempDir.path}${Platform.pathSeparator}openapi.json',
      );
      specFile.writeAsStringSync('''
{
  "openapi": "3.0.0",
  "info": { "title": "Metrics API", "version": "1.0.0" },
  "paths": {
    "/metrics": {
      "get": {
        "operationId": "listMetrics",
        "summary": "List metrics"
      }
    }
  }
}
''');

      final runner = createDartStreamCommandRunner(workingDirectory: tempDir);
      await runner.run([
        'generate',
        '--type',
        'client',
        '--name',
        'Metrics',
        '--spec',
        specFile.path,
      ]);

      final packageDir = Directory(
        '${tempDir.path}${Platform.pathSeparator}generated_clients'
        '${Platform.pathSeparator}ds_metrics_client',
      );
      expect(packageDir.existsSync(), isTrue);
      expect(
        File(
          '${packageDir.path}${Platform.pathSeparator}lib'
          '${Platform.pathSeparator}src${Platform.pathSeparator}metrics_client.dart',
        ).readAsStringSync(),
        contains('Future<DSClientResponse> listMetrics'),
      );
    },
  );

  test('login requires a token', () async {
    final runner = createDartStreamCommandRunner();

    await expectLater(
      () => runner.run(['login']),
      throwsA(isA<UsageException>()),
    );
  });
}
