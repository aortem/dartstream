import 'dart:convert';
import 'dart:io';

import 'package:ds_dartstream/src/cli/extension_registry.dart';
import 'package:test/test.dart';

void main() {
  final cli = File('bin/dartstream.dart').absolute.path;
  final packages = File('.dart_tool/package_config.json').absolute.path;
  late Directory project;
  late File registry;
  setUp(() {
    project = Directory.systemTemp.createTempSync('extensions_state_');
    registry = File('${project.path}/.dartstream/extensions.json');
    registry.parent.createSync();
  });
  tearDown(() => project.deleteSync(recursive: true));
  Future<ProcessResult> run(List<String> args) => Process.run(
    Platform.resolvedExecutable,
    ['--packages=$packages', cli, ...args],
    workingDirectory: project.path,
  );

  test(
    'toggle preserves customer metadata and other extension states',
    () async {
      final original = {
        'customer': {'policy': 'keep'},
        'version': 9,
        'extensions': [
          {
            'name': 'target',
            'enabled': false,
            'custom': [1, 2],
            'level': 'core',
          },
          {'name': 'other', 'enabled': false, 'custom': 'keep'},
        ],
      };
      registry.writeAsStringSync(jsonEncode(original));
      final enabled = await run(['enable-extension', 'target']);
      expect(enabled.exitCode, 0, reason: enabled.stderr.toString());
      final expected = jsonDecode(jsonEncode(original));
      expected['extensions'][0]['enabled'] = true;
      expect(jsonDecode(registry.readAsStringSync()), expected);
      final disabled = await run(['disable-extension', 'target']);
      expect(disabled.exitCode, 0, reason: disabled.stderr.toString());
      expect(jsonDecode(registry.readAsStringSync()), original);
    },
  );

  test(
    'same state is byte-identical and legacy registration preserves metadata',
    () async {
      const original =
          '{ "customer": "keep", "extensions": [{"name":"target","enabled":false}] }\n';
      registry.writeAsStringSync(original);
      expect((await run(['disable-extension', 'target'])).exitCode, 0);
      expect(registry.readAsStringSync(), original);
      expect((await run(['enable-extension', 'new'])).exitCode, 0);
      final state = jsonDecode(registry.readAsStringSync());
      expect(state['customer'], 'keep');
      expect(state['extensions'], [
        {'name': 'target', 'enabled': false},
        {'name': 'new', 'enabled': true},
      ]);
    },
  );

  test(
    'enabled dependents block disabling without changing registry bytes',
    () async {
      for (final dependency in ['target', 'target >=1.0.0']) {
        final original = jsonEncode({
          'customer': {'policy': 'keep'},
          'extensions': [
            {
              'name': 'target',
              'enabled': true,
              'custom': [1, 2],
            },
            {
              'name': 'dependent',
              'enabled': true,
              'dependencies': [dependency],
            },
          ],
        });
        registry.writeAsStringSync(original);
        final result = await run(['disable-extension', 'target']);
        expect(result.exitCode, isNot(0), reason: result.stdout.toString());
        expect(result.stderr, contains('dependent'));
        expect(result.stderr, contains('--force'));
        expect(registry.readAsStringSync(), original);
        expect(registry.parent.listSync().length, 1);
      }
    },
  );

  test(
    'explicit force disables only the target and preserves dependents',
    () async {
      final original = <String, dynamic>{
        'customer': {'policy': 'keep'},
        'extensions': [
          {
            'name': 'target',
            'enabled': true,
            'custom': [1, 2],
          },
          {
            'name': 'dependent',
            'enabled': true,
            'dependencies': ['target >=1.0.0'],
          },
        ],
      };
      registry.writeAsStringSync(jsonEncode(original));
      final result = await run(['disable-extension', '--force', 'target']);
      expect(result.exitCode, 0, reason: result.stderr.toString());
      original['extensions']![0]['enabled'] = false;
      expect(jsonDecode(registry.readAsStringSync()), original);
    },
  );

  test(
    'disabled dependents and similarly named dependencies do not block',
    () async {
      registry.writeAsStringSync(
        jsonEncode({
          'extensions': [
            {'name': 'target', 'enabled': true},
            {
              'name': 'disabled',
              'enabled': false,
              'dependencies': ['target'],
            },
            {
              'name': 'other',
              'enabled': true,
              'dependencies': ['target_extra >=1.0.0'],
            },
          ],
        }),
      );
      final result = await run(['disable-extension', 'target']);
      expect(result.exitCode, 0, reason: result.stderr.toString());
      final entries = jsonDecode(registry.readAsStringSync())['extensions'];
      expect(entries[0]['enabled'], false);
      expect(entries[1]['enabled'], false);
      expect(entries[2]['enabled'], true);
    },
  );

  test('already disabled dependency remains a byte-identical no-op', () async {
    const original =
        '{ "extensions": [{"name":"target","enabled":false},'
        '{"name":"dependent","enabled":true,"dependencies":["target"]}] }\n';
    registry.writeAsStringSync(original);
    expect((await run(['disable-extension', 'target'])).exitCode, 0);
    expect(registry.readAsStringSync(), original);
  });

  test('force does not bypass malformed dependency metadata', () async {
    for (final dependencies in [
      null,
      'target',
      [7],
      [''],
      [' >=1.0.0'],
    ]) {
      final original = jsonEncode({
        'extensions': [
          {'name': 'target', 'enabled': true},
          {'name': 'dependent', 'enabled': true, 'dependencies': dependencies},
        ],
      });
      registry.writeAsStringSync(original);
      final result = await run(['disable-extension', '--force', 'target']);
      expect(result.exitCode, isNot(0), reason: '$dependencies was accepted');
      expect(registry.readAsStringSync(), original);
    }
  });

  test(
    'invalid existing registries are rejected without dropping entries',
    () async {
      for (final original in [
        '[]',
        '{}',
        '{',
        '{"extensions":[{"name":"valid","enabled":false},7]}',
        '{"extensions":[{"name":"same"},{"name":"same"}]}',
        '{"extensions":[{"name":"target","enabled":"false"}]}',
      ]) {
        for (final command in [
          'enable-extension',
          'disable-extension',
          'extensions',
        ]) {
          registry.writeAsStringSync(original);
          final result = await run([
            command,
            if (command != 'extensions') 'target',
          ]);
          expect(
            result.exitCode,
            isNot(0),
            reason: '$command accepted $original',
          );
          expect(registry.readAsStringSync(), original);
          expect(registry.parent.listSync().length, 1);
        }
      }
    },
    timeout: const Timeout(Duration(seconds: 400)),
  );

  test('concurrent registry edits are preserved with staging removed', () {
    registry.writeAsStringSync(
      '{"extensions":[{"name":"target","enabled":false}]}',
    );
    final pending = ExtensionRegistry(project);
    (pending.state['extensions'] as List)[0]['enabled'] = true;
    const concurrent = '{"customer":"new","extensions":[]}';
    registry.writeAsStringSync(concurrent);
    expect(pending.save, throwsA(isA<FileSystemException>()));
    expect(registry.readAsStringSync(), concurrent);
    expect(registry.parent.listSync().length, 1);
  });

  test('linked registry directory cannot read or alter outside state', () async {
    final outside = Directory.systemTemp.createTempSync('extensions_outside_');
    final external = File('${outside.path}/extensions.json')
      ..writeAsStringSync('{"extensions":[{"name":"target","enabled":false}]}');
    final original = external.readAsStringSync();
    registry.parent.deleteSync();
    final link = Link(registry.parent.path);
    if (Platform.isWindows) {
      final result = Process.runSync('powershell.exe', [
        '-NoProfile',
        '-Command',
        "New-Item -ItemType Junction -Path '${link.path.replaceAll("'", "''")}' -Target '${outside.path.replaceAll("'", "''")}' -ErrorAction Stop | Out-Null",
      ]);
      expect(result.exitCode, 0, reason: '${result.stderr}');
    } else {
      link.createSync(outside.path);
    }
    try {
      for (final command in [
        'enable-extension',
        'disable-extension',
        'extensions',
      ]) {
        final result = await run([
          command,
          if (command != 'extensions') 'target',
        ]);
        expect(result.exitCode, isNot(0), reason: '$command followed a link');
        expect(external.readAsStringSync(), original);
        expect(outside.listSync().length, 1);
      }
    } finally {
      link.deleteSync();
      outside.deleteSync(recursive: true);
    }
  });
}
