import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ds_dartstream/src/cli/configure_file.dart';
import 'package:ds_dartstream/src/cli/dartstream_cli.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  late Directory directory;
  late File config;
  late CommandRunner<void> runner;
  setUp(() {
    directory = Directory.systemTemp.createTempSync('ds_configure_');
    config = File('${directory.path}/dartstream.yaml');
    runner = createDartStreamCommandRunner(workingDirectory: directory);
  });
  tearDown(() => directory.deleteSync(recursive: true));

  test('new file gets valid defaults and no unrelated files', () async {
    await runner.run(['configure', '--name', 'my_app']);
    final data = loadYaml(config.readAsStringSync());
    expect(data['name'], 'my_app');
    expect(data['cloud']['vendor'], 'local');
    expect(data['auth']['provider'], 'firebase');
    expect(data['database']['provider'], 'postgres');
    expect(data['cicd']['provider'], 'gitlab');
    expect(data['cloud_features'], false);
    expect(data['examples'], true);
    expect(directory.listSync().length, 1);
  });

  test(
    'explicit fields merge and preserve comments, nested keys and disabled extensions',
    () async {
      config.writeAsStringSync('''# customer settings
name: original
cloud:
  vendor: local # keep this comment
  region: keep-region
custom: keep
extensions:
  - name: private
    enabled: false
''');
      final state = File('${directory.path}/extensions.json')
        ..writeAsStringSync('{"enabled":false}');
      await runner.run(['configure', '--vendor', 'gcp']);
      final text = config.readAsStringSync();
      final data = loadYaml(text);
      expect(text, contains('# customer settings'));
      expect(text, contains('# keep this comment'));
      expect(data['name'], 'original');
      expect(data['cloud']['vendor'], 'gcp');
      expect(data['cloud']['region'], 'keep-region');
      expect(data['custom'], 'keep');
      expect(data['extensions'][0]['enabled'], false);
      expect(data.containsKey('auth'), false);
      expect(state.readAsStringSync(), '{"enabled":false}');
    },
  );

  for (final sample in <String, List<Object>>{
    'name': [
      'new_name',
      ['name'],
    ],
    'vendor': [
      'azure',
      ['cloud', 'vendor'],
    ],
    'auth': [
      'oidc',
      ['auth', 'provider'],
    ],
    'database': [
      'mongodb',
      ['database', 'provider'],
    ],
    'cicd': [
      'github',
      ['cicd', 'provider'],
    ],
  }.entries) {
    test('${sample.key} changes its documented setting only', () async {
      config.writeAsStringSync('custom: keep\n');
      await runner.run([
        'configure',
        '--${sample.key}',
        sample.value[0] as String,
      ]);
      dynamic value = loadYaml(config.readAsStringSync());
      expect(value['custom'], 'keep');
      for (final key in sample.value[1] as List<String>) {
        value = value[key];
      }
      expect(value, sample.value[0]);
    });
  }

  test('positive and negative boolean flags have observable effects', () async {
    await runner.run(['configure', '--cloud-features', '--skip-examples']);
    var data = loadYaml(config.readAsStringSync());
    expect(data['cloud_features'], true);
    expect(data['examples'], false);
    await runner.run([
      'configure',
      '--no-cloud-features',
      '--no-skip-examples',
    ]);
    data = loadYaml(config.readAsStringSync());
    expect(data['cloud_features'], false);
    expect(data['examples'], true);
  });

  test('no options and repeated value preserve file bytes', () async {
    const original = '# comment\nname: my_app\ncustom: keep\n';
    config.writeAsStringSync(original);
    await runner.run(['configure']);
    await runner.run(['configure', '--name', 'my_app']);
    expect(config.readAsStringSync(), original);
  });

  test('force is required to replace the whole file', () async {
    config.writeAsStringSync('custom: keep\nname: old\n');
    await runner.run(['configure', '--name', 'new']);
    expect(loadYaml(config.readAsStringSync())['custom'], 'keep');
    await runner.run(['configure', '--force', '--name', 'replacement']);
    final data = loadYaml(config.readAsStringSync());
    expect(data.containsKey('custom'), false);
    expect(data['name'], 'replacement');
    expect(data['cloud']['vendor'], 'local');
  });

  for (final original in [
    'cloud: scalar\n',
    'cloud: null\n',
    '- a\n',
    'a: [',
  ]) {
    test('invalid shape or syntax is preserved: $original', () async {
      config.writeAsStringSync(original);
      await expectLater(
        runner.run(['configure', '--vendor', 'gcp']),
        throwsA(isA<UsageException>()),
      );
      expect(config.readAsStringSync(), original);
    });
  }

  test(
    'force can replace malformed content and values cannot inject YAML',
    () async {
      config.writeAsStringSync('a: [');
      await runner.run([
        'configure',
        '--force',
        '--name',
        'quoted: value\ncustom: false',
      ]);
      final data = loadYaml(config.readAsStringSync());
      expect(data['name'], 'quoted: value\ncustom: false');
      expect(data.containsKey('custom'), false);
    },
  );

  test(
    'change list identifies edits without printing previous customer values',
    () async {
      config.writeAsStringSync('name: private-customer-value\n');
      final changes = await configureFile(config, {
        'name': 'new',
      }, defaultName: 'app');
      expect(changes, ['~ name: new']);
    },
  );

  test('invalid enum flag does not create a file', () async {
    await expectLater(
      runner.run(['configure', '--vendor', 'invalid']),
      throwsA(isA<UsageException>()),
    );
    expect(config.existsSync(), false);
  });
}
