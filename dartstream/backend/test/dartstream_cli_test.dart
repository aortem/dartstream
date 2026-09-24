import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ds_dartstream/src/cli/dartstream_cli.dart';
import 'package:test/test.dart';

const validCliToken = 'secret_0123456789abcdef0123456789abcdef';

void main() {
  test('global version flags report the published package version', () {
    expect(dartStreamCliVersionOutput(['--version']), 'ds_dartstream 0.0.10');
    expect(dartStreamCliVersionOutput(['-v']), 'ds_dartstream 0.0.10');
    expect(dartStreamCliVersionOutput(['validate']), isNull);
  });

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
      await runner.run(['validate']);
      final entrypoint = File('${tempDir.path}/bin/sample_app.dart');
      expect(entrypoint.readAsStringSync(), contains('package:sample_app/main.dart'));
      entrypoint.writeAsStringSync('// customer entrypoint');
      await runner.run(['init', '--name', 'sample_app']);
      expect(entrypoint.readAsStringSync(), '// customer entrypoint');
      await runner.run(['init', '--name', 'sample_app', '--force']);
      expect(entrypoint.readAsStringSync(), contains('application.main()'));


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

  test('unfinished commands never alter existing files or create new files', () async {
    final temp = Directory.systemTemp.createTempSync('cli_guard_');
    addTearDown(() => temp.deleteSync(recursive: true));
    File('${temp.path}/dartstream.yaml').writeAsStringSync('custom: keep');
    Directory('${temp.path}/.dartstream').createSync();
    File('${temp.path}/.dartstream/setup.json').writeAsStringSync('{"custom":true}');
    File('${temp.path}/.dartstream/extensions.json').writeAsStringSync('{"extensions":[{"name":"custom","enabled":false}]}');
    Map<String,String> snapshot() => {for (final f in temp.listSync(recursive: true).whereType<File>()) f.path: f.readAsStringSync()};
    final before = snapshot();
    final runner = createDartStreamCommandRunner(workingDirectory: temp);
    for (final args in [ ['configure'], ['setup'], ['generate','--type','model'], ['discover','--register'] ]) {
      await expectLater(runner.run(args), throwsA(isA<UsageException>().having((e) => e.message, 'message', startsWith('Coming soon'))));
      expect(snapshot(), before);
      expect(runner.commands[args.first]!.description, contains('coming soon'));
    }
  });

  test('login requires a token', () async {
    final runner = createDartStreamCommandRunner();

    await expectLater(
      () => runner.run(['login']),
      throwsA(isA<UsageException>()),
    );
  });

  test('login rejects malformed tokens before saving credentials', () async {
    final tempDir = Directory.systemTemp.createTempSync(
      'dartstream_cli_invalid_login_test_',
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
