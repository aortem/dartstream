import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ds_dartstream/src/cli/dartstream_cli.dart';
import 'package:ds_dartstream/src/cli/discover_extensions.dart';
import 'package:test/test.dart';

void main() {
  late Directory project;
  late File registry;
  setUp(() {
    project = Directory.systemTemp.createTempSync('ds_discover_');
    registry = File('${project.path}/.dartstream/extensions.json');
  });
  tearDown(() => project.deleteSync(recursive: true));
  File manifest(String folder, String name, {String entry = 'lib/main.dart'}) {
    final directory = Directory('${project.path}/packages/$folder/lib')
      ..createSync(recursive: true);
    File(
      '${directory.path}/main.dart',
    ).writeAsStringSync("throw 'must not run';\n");
    return File('${directory.parent.path}/manifest.yaml')..writeAsStringSync(
      'name: $name\nversion: 1.0.0\nentry_point: $entry\nlevel: core\ndependencies: []\n',
    );
  }

  void state(Map<String, dynamic> value) {
    registry.parent.createSync(recursive: true);
    registry.writeAsStringSync(jsonEncode(value));
  }

  test(
    'public command registers real manifests, not arbitrary packages, without executing code',
    () async {
      manifest('auth', 'CustomerAuth');
      File(
        '${project.path}/packages/pubspec.yaml',
      ).writeAsStringSync('name: not_an_extension');
      await createDartStreamCommandRunner(
        workingDirectory: project,
      ).run(['discover']);
      final entries =
          jsonDecode(registry.readAsStringSync())['extensions'] as List;
      expect(entries, hasLength(1));
      expect(entries.single['name'], 'CustomerAuth');
      expect(entries.single['entry_point'], 'packages/auth/lib/main.dart');
      expect(entries.single['version'], '1.0.0');
    },
  );
  test(
    'retains disabled state, customer metadata and undiscovered entries; rerun preserves bytes',
    () {
      manifest('auth', 'CustomerAuth');
      state({
        'custom': {'keep': 7},
        'extensions': [
          {'name': 'CustomerAuth', 'enabled': false, 'custom': 'preserve'},
          {'name': 'manual', 'enabled': false},
        ],
      });
      discoverExtensions(project, register: true);
      final value = jsonDecode(registry.readAsStringSync());
      expect(value['custom'], {'keep': 7});
      expect(value['extensions'][0]['enabled'], false);
      expect(value['extensions'][0]['custom'], 'preserve');
      expect(value['extensions'][1], {'name': 'manual', 'enabled': false});
      final before = registry.readAsBytesSync();
      discoverExtensions(project, register: true);
      expect(registry.readAsBytesSync(), before);
    },
  );
  test('no-register reads real manifests without creating state', () async {
    manifest('auth', 'CustomerAuth');
    await createDartStreamCommandRunner(
      workingDirectory: project,
    ).run(['discover', '--no-register']);
    expect(registry.parent.existsSync(), false);
  });
  test('no manifests leaves existing registry bytes alone', () {
    state({
      'extensions': [
        {'name': 'manual', 'enabled': false},
      ],
    });
    final before = registry.readAsBytesSync();
    expect(discoverExtensions(project, register: true), isEmpty);
    expect(registry.readAsBytesSync(), before);
  });
  test('duplicate names fail before changing registry', () {
    manifest('one', 'Same');
    manifest('two', 'Same');
    state({'extensions': []});
    final before = registry.readAsBytesSync();
    expect(
      () => discoverExtensions(project, register: true),
      throwsFormatException,
    );
    expect(registry.readAsBytesSync(), before);
  });
  test('missing and escaping entry points fail without writes', () {
    final f = manifest('one', 'One', entry: '../../outside.dart');
    File('${project.path}/outside.dart').writeAsStringSync('void main() {}');
    expect(
      () => discoverExtensions(project, register: true),
      throwsFormatException,
    );
    f.writeAsStringSync(
      'name: One\nversion: 1.0.0\nentry_point: lib/missing.dart\n',
    );
    expect(
      () => discoverExtensions(project, register: true),
      throwsFormatException,
    );
    expect(registry.existsSync(), false);
  });
  test('malformed manifest and invalid metadata fail before writes', () {
    final f = manifest('one', 'One');
    for (final text in [
      '[]',
      'name: One\nversion: 1\nentry_point: lib/main.dart\n',
      'name: One\nversion: 1.0.0\nentry_point: lib/main.dart\ndependencies: [4]\n',
    ]) {
      f.writeAsStringSync(text);
      expect(
        () => discoverExtensions(project, register: true),
        throwsFormatException,
      );
      expect(registry.existsSync(), false);
    }
  });
  test('malformed existing registry is preserved', () {
    manifest('one', 'One');
    registry.parent.createSync(recursive: true);
    for (final text in [
      'not json',
      '{"extensions":{}}',
      '{"extensions":[4]}',
      '{"extensions":[{"name":"x","enabled":"false"}]}',
    ]) {
      registry.writeAsStringSync(text);
      expect(
        () => discoverExtensions(project, register: true),
        throwsFormatException,
      );
      expect(registry.readAsStringSync(), text);
    }
  });
  test(
    'project option selects the directory and no-validate cannot bypass checks',
    () async {
      manifest('one', 'One');
      final runner = createDartStreamCommandRunner(
        workingDirectory: project.parent,
      );
      await expectLater(
        runner.run(['discover', '--project', project.path, '--no-validate']),
        throwsA(isA<UsageException>()),
      );
      expect(registry.existsSync(), false);
      await runner.run(['discover', '--project', project.path]);
      expect(registry.existsSync(), true);
    },
  );
}
