import 'dart:io';

import 'package:yaml/yaml.dart';

/// Creates local validation CI only. Existing customer files are retained.
Future<String> setupValidationCi(Directory project) async {
  final configuration = File('${project.path}/dartstream.yaml');
  if (await FileSystemEntity.type(configuration.path, followLinks: false) !=
      FileSystemEntityType.file) {
    throw const FormatException(
      'Run init/configure first; dartstream.yaml must be a regular file.',
    );
  }
  final parsed = loadYaml(await configuration.readAsString());
  if (parsed is! Map) {
    throw const FormatException('dartstream.yaml must be a YAML mapping.');
  }
  final ci = parsed['cicd'];
  if (ci is! Map || ci['provider'] is! String) {
    throw const FormatException('Configure cicd.provider before setup.');
  }
  if (ci['provider'] == 'none') return 'No CI requested (cicd.provider: none).';
  if (ci['provider'] != 'gitlab') {
    throw const FormatException(
      'Local CI setup currently supports gitlab or none; other providers are coming soon.',
    );
  }
  final manifest = File('${project.path}/pubspec.yaml');
  if (await FileSystemEntity.type(manifest.path, followLinks: false) !=
      FileSystemEntityType.file) {
    throw const FormatException(
      'pubspec.yaml must be a regular file; no files changed.',
    );
  }
  final target = File('${project.path}/.gitlab-ci.yml');
  final type = await FileSystemEntity.type(target.path, followLinks: false);
  if (type == FileSystemEntityType.file) {
    return 'Existing .gitlab-ci.yml retained; add validation to it manually.';
  }
  if (type != FileSystemEntityType.notFound) {
    throw const FormatException(
      '.gitlab-ci.yml must not be a link or directory; no files changed.',
    );
  }
  final specification = loadYaml(await manifest.readAsString());
  if (specification is! Map ||
      ![
        specification['dependencies'],
        specification['dev_dependencies'],
      ].any((section) => section is Map && section.containsKey('test'))) {
    throw const FormatException(
      'Add the test package and a test suite before configuring validation CI; no files changed.',
    );
  }
  final tests = Directory('${project.path}/test');
  if (await FileSystemEntity.type(tests.path, followLinks: false) !=
          FileSystemEntityType.directory ||
      !await tests
          .list(recursive: true, followLinks: false)
          .any((entry) => entry is File && entry.path.endsWith('_test.dart'))) {
    throw const FormatException(
      'Add test/*_test.dart before configuring validation CI; no files changed.',
    );
  }
  // Keep the official SDK immutable, matching the reviewed CI base. This file
  // starts no deployment or cloud provisioning and contains no credentials.
  final temporary = await project.createTemp('.dartstream-setup-');
  try {
    final candidate = File('${temporary.path}/ci.yml');
    await candidate.writeAsString(validationCi, flush: true);
    if (await FileSystemEntity.type(target.path, followLinks: false) !=
        FileSystemEntityType.notFound) {
      throw const FileSystemException(
        'CI file changed during setup; retry after reviewing it.',
      );
    }
    await candidate.rename(target.path);
  } finally {
    await temporary.delete(recursive: true);
  }
  return 'Created .gitlab-ci.yml for dependency resolution, analysis and tests. No deployment configured.';
}

const validationCi =
    '''# DartStream local validation. Review changes through your normal MR gates.
# Official Dart SDK 3.13.4; immutable digest from the reviewed CI base.
image: dart@sha256:33faf91bc941466a767ce845b4bbb5d578ecd180abe5ee243e9c8c039109d215

stages: [validate]

dartstream:validate:
  stage: validate
  script:
    - dart pub get
    - dart analyze --fatal-infos
    - dart test
''';
