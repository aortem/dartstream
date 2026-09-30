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
    for (final provider in ['github', 'custom', '../escape']) {
      await File(
        '${project.path}/dartstream.yaml',
      ).writeAsString('cicd: {provider: $provider}\n');
      await expectLater(setupValidationCi(project), throwsFormatException);
      expect(await File('${project.path}/.gitlab-ci.yml').exists(), isFalse);
    }
  });
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
