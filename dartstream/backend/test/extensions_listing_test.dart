import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  final cli = File('bin/dartstream.dart').absolute.path;
  final packages = File('.dart_tool/package_config.json').absolute.path;
  late Directory project;
  late File registry;
  late String original;

  setUp(() {
    project = Directory.systemTemp.createTempSync('extensions_listing_');
    registry = File('${project.path}/.dartstream/extensions.json');
    registry.parent.createSync();
    original = jsonEncode({
      'customer': 'preserve registry metadata',
      'extensions': [
        {'name': 'core_on', 'level': 'core', 'enabled': true},
        {'name': 'core_off', 'level': 'core', 'enabled': false},
        {'name': 'extended_on', 'level': 'extended', 'enabled': true},
        {'name': 'maintained_on', 'level': 'thirdParty', 'enabled': true},
        {'name': 'third_off', 'level': 'third-party', 'enabled': false},
        {'name': 'legacy_on', 'enabled': true, 'customer': 'keep'},
      ],
    });
    registry.writeAsStringSync(original);
  });

  tearDown(() {
    expect(registry.readAsStringSync(), original);
    project.deleteSync(recursive: true);
  });

  Future<ProcessResult> run(List<String> args) => Process.run(
    Platform.resolvedExecutable,
    ['--packages=$packages', cli, 'extensions', ...args],
    workingDirectory: project.path,
  );

  Future<List<dynamic>> listing(List<String> args) async {
    final result = await run([...args, '--json']);
    expect(result.exitCode, 0, reason: result.stderr.toString());
    final data = jsonDecode(result.stdout as String) as Map<String, dynamic>;
    return data['extensions'] as List<dynamic>;
  }

  test('default JSON listing excludes disabled extensions', () async {
    expect((await listing([])).map((entry) => entry['name']), [
      'core_on',
      'extended_on',
      'maintained_on',
      'legacy_on',
    ]);
  });

  test('inactive includes disabled entries without enabling them', () async {
    final entries = await listing(['--inactive']);
    expect(entries, hasLength(6));
    expect(entries.where((entry) => entry['enabled'] == false), hasLength(2));
  });

  test(
    'level applies to core, extended, maintained and legacy entries',
    () async {
      for (final scope in {
        'core': ['core_on'],
        'extended': ['extended_on'],
        'third-party': ['maintained_on', 'legacy_on'],
      }.entries) {
        expect(
          (await listing(['--level', scope.key])).map((entry) => entry['name']),
          scope.value,
        );
      }
    },
  );

  test('short flags apply both filters to text and JSON output', () async {
    final entries = await listing(['-l', 'core', '-i']);
    expect(entries.map((entry) => entry['name']), ['core_on', 'core_off']);
    final result = await run(['-l', 'core', '-i']);
    expect(result.exitCode, 0);
    expect(result.stdout, contains('core_on (enabled)'));
    expect(result.stdout, contains('core_off (disabled)'));
    expect(result.stdout, contains('Total: 2'));
    expect(result.stdout, isNot(contains('extended_on')));
  });

  test('empty and invalid filters leave the registry unchanged', () async {
    registry.writeAsStringSync('{"extensions":[]}');
    original = registry.readAsStringSync();
    final empty = await run(['--level', 'extended']);
    expect(empty.exitCode, 0);
    expect(empty.stdout, contains('No registered extensions match'));
    final invalid = await run(['--level', 'unsupported']);
    expect(invalid.exitCode, 64);
  });
}
