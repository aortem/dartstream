import 'dart:io';

import 'package:ds_dartstream/src/cli/dartstream_cli.dart';
import 'package:ds_dartstream/src/cli/setup_ci.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  late Directory project;
  setUp(() async {
    project = await Directory.systemTemp.createTemp('ds-setup-ci-');
    await File('${project.path}/dartstream.yaml').writeAsString(
      'name: example\ncicd:\n  provider: gitlab\ncustom: retain\n',
    );
    await File('${project.path}/pubspec.yaml').writeAsString(
      'name: example\nenvironment: {sdk: ^3.12.2}\ndev_dependencies: {test: ^1.26.0}\n',
    );
    await Directory('${project.path}/test').create();
    await File('${project.path}/test/example_test.dart').writeAsString(
      "import 'package:test/test.dart';\nvoid main() { test('example', () => expect(2 + 2, 4)); }\n",
    );
  });
  tearDown(() => project.delete(recursive: true));
  test(
    'real command writes valid pinned CI and preserves config/manifest',
    () async {
      final config = await File(
        '${project.path}/dartstream.yaml',
      ).readAsString();
      final manifest = await File(
        '${project.path}/pubspec.yaml',
      ).readAsString();
      await createDartStreamCommandRunner(
        workingDirectory: project,
      ).run(['setup']);
      final text = await File('${project.path}/.gitlab-ci.yml').readAsString();
      final yaml = loadYaml(text) as YamlMap;
      expect(yaml['image'], matches(r'^dart@sha256:[a-f0-9]{64}$'));
      expect(yaml['dartstream:validate']['script'], [
        'dart pub get',
        'dart analyze --fatal-infos',
        'dart test',
      ]);
      expect(
        await File('${project.path}/dartstream.yaml').readAsString(),
        config,
      );
      expect(
        await File('${project.path}/pubspec.yaml').readAsString(),
        manifest,
      );
      expect(
        text,
        isNot(contains('deploy')),
      ); // only the command output discusses deployment
    },
  );
  test('repeat setup retains edited customer CI byte for byte', () async {
    final file = File('${project.path}/.gitlab-ci.yml');
    await setupValidationCi(project);
    await file.writeAsString('# customer CI\ninclude: company.yml\n');
    expect(await setupValidationCi(project), contains('retained'));
    expect(await file.readAsString(), '# customer CI\ninclude: company.yml\n');
  });
  test('none produces no CI file', () async {
    await File(
      '${project.path}/dartstream.yaml',
    ).writeAsString('cicd: {provider: none}\n');
    expect(await setupValidationCi(project), contains('No CI requested'));
    expect(await File('${project.path}/.gitlab-ci.yml').exists(), isFalse);
  });
  test('unsupported providers fail before writing', () async {
    for (final provider in ['custom', '../escape']) {
      await File(
        '${project.path}/dartstream.yaml',
      ).writeAsString('cicd: {provider: $provider}\n');
      await expectLater(setupValidationCi(project), throwsFormatException);
      expect(await File('${project.path}/.gitlab-ci.yml').exists(), isFalse);
    }
  });
  test(
    'GitHub setup creates pinned read-only validation and retains edits',
    () async {
      final config = File('${project.path}/dartstream.yaml');
      await config.writeAsString('cicd: {provider: github}\ncustom: retain\n');
      final original = await config.readAsString();
      await createDartStreamCommandRunner(
        workingDirectory: project,
      ).run(['setup']);
      final file = File(
        '${project.path}/.github/workflows/dartstream-validation.yml',
      );
      final workflow = loadYaml(await file.readAsString()) as YamlMap;
      expect(workflow['on'], ['push', 'pull_request']);
      expect(workflow['permissions'], {'contents': 'read'});
      final job = workflow['jobs']['validate'];
      expect(job['container']['image'], matches(r'^dart@sha256:[a-f0-9]{64}$'));
      expect(job['runs-on'], 'ubuntu-24.04');
      expect(
        job['steps'][0]['uses'],
        matches(r'^actions/checkout@[a-f0-9]{40}$'),
      );
      expect(job['steps'][0]['with']['persist-credentials'], isFalse);
      expect(job['steps'].skip(1).map((step) => step['run']).toList(), [
        'dart pub get',
        'dart analyze --fatal-infos',
        'dart test',
      ]);
      expect(await config.readAsString(), original);
      expect(await File('${project.path}/.gitlab-ci.yml').exists(), isFalse);
      await file.writeAsString('# customer workflow\n');
      expect(await setupValidationCi(project), contains('retained'));
      expect(await file.readAsString(), '# customer workflow\n');
    },
  );
  test(
    'GitHub setup rejects a conflicting parent without creating CI',
    () async {
      await File(
        '${project.path}/dartstream.yaml',
      ).writeAsString('cicd: {provider: github}\n');
      final conflict = File('${project.path}/.github')
        ..writeAsStringSync('customer');
      await expectLater(setupValidationCi(project), throwsFormatException);
      expect(conflict.readAsStringSync(), 'customer');
      expect(await File('${project.path}/.gitlab-ci.yml').exists(), isFalse);
    },
  );
  test('malformed configuration fails before writing', () async {
    for (final config in ['[1,2]\n', 'cicd: text\n', 'cicd: {}\n']) {
      await File('${project.path}/dartstream.yaml').writeAsString(config);
      await expectLater(setupValidationCi(project), throwsFormatException);
      expect(await File('${project.path}/.gitlab-ci.yml').exists(), isFalse);
    }
  });
  test('CI directory is never replaced', () async {
    await Directory('${project.path}/.gitlab-ci.yml').create();
    await expectLater(setupValidationCi(project), throwsFormatException);
    expect(await Directory('${project.path}/.gitlab-ci.yml').exists(), isTrue);
  });
  test(
    'GitHub refuses linked workflow parents and preserves outside files',
    () async {
      await File(
        '${project.path}/dartstream.yaml',
      ).writeAsString('cicd: {provider: github}\n');
      final outside = await Directory.systemTemp.createTemp('ds-ci-outside-');
      final external = File('${outside.path}/dartstream-validation.yml');
      await external.writeAsString('# external customer workflow\n');
      await Directory('${project.path}/.github').create();
      final link = Link('${project.path}/.github/workflows');
      if (Platform.isWindows) {
        final result = await Process.run('powershell.exe', [
          '-NoProfile',
          '-Command',
          "New-Item -ItemType Junction -Path '${link.path.replaceAll("'", "''")}' -Target '${outside.path.replaceAll("'", "''")}' -ErrorAction Stop | Out-Null",
        ]);
        expect(result.exitCode, 0, reason: '${result.stderr}');
      } else {
        await link.create(outside.path);
      }
      try {
        await expectLater(setupValidationCi(project), throwsFormatException);
        expect(await external.readAsString(), '# external customer workflow\n');
        expect(await outside.list().length, 1);
      } finally {
        await link.delete();
        await outside.delete(recursive: true);
      }
    },
  );
  test(
    'GitHub validates prerequisites before creating workflow directories',
    () async {
      await File(
        '${project.path}/dartstream.yaml',
      ).writeAsString('cicd: {provider: github}\n');
      await File('${project.path}/test/example_test.dart').delete();
      await expectLater(setupValidationCi(project), throwsFormatException);
      expect(await Directory('${project.path}/.github').exists(), isFalse);
    },
  );
  test('GitHub setup preserves other workflows and extension state', () async {
    await File(
      '${project.path}/dartstream.yaml',
    ).writeAsString('cicd: {provider: github}\n');
    final other = File('${project.path}/.github/workflows/customer.yml');
    await other.parent.create(recursive: true);
    await other.writeAsString('# company validation\n');
    final state = File('${project.path}/.dartstream/extensions.json');
    await state.parent.create();
    await state.writeAsString(
      '{"extensions":[{"name":"custom","enabled":false}]}',
    );
    await setupValidationCi(project);
    expect(await other.readAsString(), '# company validation\n');
    expect(
      await state.readAsString(),
      '{"extensions":[{"name":"custom","enabled":false}]}',
    );
  });
  test('missing test dependency or suite fails without weakening CI', () async {
    final manifest = File('${project.path}/pubspec.yaml');
    final original = await manifest.readAsString();
    await manifest.writeAsString('name: example\n');
    await expectLater(setupValidationCi(project), throwsFormatException);
    expect(await File('${project.path}/.gitlab-ci.yml').exists(), isFalse);
    await manifest.writeAsString(original);
    await File('${project.path}/test/example_test.dart').delete();
    await expectLater(setupValidationCi(project), throwsFormatException);
    expect(await File('${project.path}/.gitlab-ci.yml').exists(), isFalse);
  });
  test(
    'generated CI commands execute successfully in an independent project',
    () async {
      await File(
        '${project.path}/dartstream.yaml',
      ).writeAsString('cicd: {provider: github}\n');
      await setupValidationCi(project);
      for (final arguments in [
        ['pub', 'get'],
        ['analyze', '--fatal-infos'],
        ['test'],
      ]) {
        final result = await Process.run(
          Platform.resolvedExecutable,
          arguments,
          workingDirectory: project.path,
        );
        expect(
          result.exitCode,
          0,
          reason: '${result.stdout}\n${result.stderr}',
        );
      }
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
  test('unsupported SaaS/tools do not produce pretend setup state', () async {
    for (final arguments in [
      ['setup', '--saas'],
      ['setup', '--features', 'security'],
      ['setup', '--name', 'other'],
    ]) {
      await expectLater(
        createDartStreamCommandRunner(workingDirectory: project).run(arguments),
        throwsA(isA<Exception>()),
      );
      expect(await File('${project.path}/.gitlab-ci.yml').exists(), isFalse);
      expect(
        await File('${project.path}/.dartstream/setup.json').exists(),
        isFalse,
      );
    }
  });
}
