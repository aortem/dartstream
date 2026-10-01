import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  final cli = File('bin/dartstream.dart').absolute.path;
  final packages = File('.dart_tool/package_config.json').absolute.path;
  late Directory project;
  late File registry;
  setUp(() {
    project = Directory.systemTemp.createTempSync('extension_level_');
    registry = File('${project.path}/.dartstream/extensions.json');
  });
  tearDown(() => project.deleteSync(recursive: true));
  Future<ProcessResult> run(List<String> args) => Process.run(
    Platform.resolvedExecutable,
    ['--packages=$packages', cli, ...args],
    workingDirectory: project.path,
  );

  test(
    'explicit enable level is persisted and used by filtered listing',
    () async {
      for (final level in ['core', 'extended', 'third-party']) {
        final result = await run(['enable-extension', '--level', level, level]);
        expect(result.exitCode, 0, reason: result.stderr.toString());
        final listing = await run(['extensions', '--level', level, '--json']);
        expect(listing.exitCode, 0, reason: listing.stderr.toString());
        final entries =
            jsonDecode(listing.stdout as String)['extensions'] as List;
        expect(entries, hasLength(1), reason: '$level was ignored');
        expect(entries.single['name'], level);
        expect(entries.single['level'], level);
      }
    },
  );

  test(
    'explicit reclassification preserves unrelated customer state',
    () async {
      registry.parent.createSync();
      final original = <String, dynamic>{
        'customer': 'keep',
        'extensions': [
          {
            'name': 'target',
            'enabled': false,
            'level': 'core',
            'version': '1.2.3',
          },
          {'name': 'other', 'enabled': true, 'level': 'core'},
        ],
      };
      registry.writeAsStringSync(jsonEncode(original));
      final result = await run([
        'enable-extension',
        '-l',
        'extended',
        'target',
      ]);
      expect(result.exitCode, 0, reason: result.stderr.toString());
      original['extensions']![0]['enabled'] = true;
      original['extensions']![0]['level'] = 'extended';
      expect(jsonDecode(registry.readAsStringSync()), original);
      final bytes = registry.readAsStringSync();
      expect(
        (await run(['enable-extension', '-l', 'extended', 'target'])).exitCode,
        0,
      );
      expect(registry.readAsStringSync(), bytes);
      final invalid = await run([
        'enable-extension',
        '--level',
        'invalid',
        'target',
      ]);
      expect(invalid.exitCode, 64);
      expect(registry.readAsStringSync(), bytes);
    },
  );
}
