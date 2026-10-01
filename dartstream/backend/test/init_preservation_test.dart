import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ds_dartstream/src/cli/dartstream_cli.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  late Directory project;
  setUp(() => project = Directory.systemTemp.createTempSync('cli_init_'));
  tearDown(() => project.deleteSync(recursive: true));

  Future<void> init(List<String> options) => createDartStreamCommandRunner(
    workingDirectory: project,
  ).run(['init', '--name', 'sample_app', ...options]);

  test('late output conflict preserves all existing starter files', () async {
    final config = File('${project.path}/pubspec.yaml')
      ..writeAsStringSync('customer: preserved\n');
    Directory(
      '${project.path}/bin/sample_app.dart',
    ).createSync(recursive: true);
    await expectLater(init(['--force']), throwsA(isA<UsageException>()));
    expect(config.readAsStringSync(), 'customer: preserved\n');
    expect(Directory('${project.path}/lib').existsSync(), isFalse);
    expect(File('${project.path}/dartstream.yaml').existsSync(), isFalse);
  });

  test('linked output directory never changes external files', () async {
    final outside = Directory.systemTemp.createTempSync('cli_init_outside_');
    final external = File('${outside.path}/sample_app.dart')
      ..writeAsStringSync('// outside customer file\n');
    final link = Link('${project.path}/bin');
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
      for (final options in [
        <String>[],
        ['--force'],
      ]) {
        await expectLater(init(options), throwsA(isA<UsageException>()));
        expect(external.readAsStringSync(), '// outside customer file\n');
        expect(outside.listSync().length, 1);
        expect(File('${project.path}/pubspec.yaml').existsSync(), isFalse);
      }
    } finally {
      link.deleteSync();
      outside.deleteSync(recursive: true);
    }
  });

  test(
    'explicit directory beneath a junction is refused before creation',
    () async {
      final outside = Directory.systemTemp.createTempSync('cli_init_target_');
      final link = Link('${project.path}/redirect');
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
        await expectLater(
          init(['--directory', 'redirect/new_project']),
          throwsA(isA<UsageException>()),
        );
        expect(outside.listSync(), isEmpty);
      } finally {
        link.deleteSync();
        outside.deleteSync(recursive: true);
      }
    },
  );

  test('project display name stays one YAML value', () async {
    const name = 'sample\ncustomer_key: injected # : quoted';
    await createDartStreamCommandRunner(
      workingDirectory: project,
    ).run(['init', '--name', name]);
    final config =
        loadYaml(File('${project.path}/dartstream.yaml').readAsStringSync())
            as YamlMap;
    expect(config['name'], name);
    expect(config.containsKey('customer_key'), isFalse);
  });
}
