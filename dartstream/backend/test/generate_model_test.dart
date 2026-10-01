import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ds_dartstream/src/cli/dartstream_cli.dart';
import 'package:ds_dartstream/src/cli/generate_model.dart';
import 'package:test/test.dart';

void main() {
  late Directory project;
  setUp(() async {
    project = await Directory.systemTemp.createTemp('ds-model-');
  });
  tearDown(() => project.delete(recursive: true));

  test(
    'documented command generates runnable JSON/equality/copy model',
    () async {
      await createDartStreamCommandRunner(
        workingDirectory: project,
      ).run(['generate', '--type', 'model', '--name', 'User']);
      final model = File('${project.path}/lib/src/models/user.dart');
      expect(await model.exists(), isTrue);
      await File(
        '${project.path}/pubspec.yaml',
      ).writeAsString('name: independent_model\nenvironment: {sdk: ^3.12.2}\n');
      await File('${project.path}/run.dart').writeAsString('''
import 'lib/src/models/user.dart';
void check(bool value) { if (!value) throw StateError('model contract failed'); }
void main() {
  final created = DateTime.utc(2026, 9, 30);
  final user = User(id: 'one', name: 'Original', createdAt: created);
  check(User.fromJson(user.toJson()) == user);
  check(!user.toJson().containsKey('updated_at'));
  final changed = user.copyWith(name: 'Changed', updatedAt: created);
  check(changed.name == 'Changed' && user.name == 'Original');
  check(changed.createdAt == created && changed.updatedAt == created);
  final roundTrip = User.fromJson(changed.toJson());
  check(roundTrip.updatedAt == created);
  check({user, changed}.length == 1);
  check(user.copyWith(id: 'two') != user);
  check(user.toString().contains('Original'));
  var rejected = false;
  try { User.fromJson({'id': 7, 'name': 'bad', 'created_at': 'invalid'}); }
  catch (_) { rejected = true; }
  check(rejected);
}
''');
      for (final args in [
        ['pub', 'get'],
        ['analyze', '--fatal-infos'],
        ['run', 'run.dart'],
      ]) {
        final result = await Process.run(
          Platform.resolvedExecutable,
          args,
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

  test('existing customer file and directory are never replaced', () async {
    final model = await generateModel(project: project, name: 'User');
    await model.writeAsString('// edited customer model\n');
    await expectLater(
      generateModel(project: project, name: 'User'),
      throwsA(isA<FileSystemException>()),
    );
    expect(await model.readAsString(), '// edited customer model\n');
    await Directory('${project.path}/lib/src/models/order.dart').create();
    await expectLater(
      generateModel(project: project, name: 'Order'),
      throwsA(isA<FileSystemException>()),
    );
    expect(
      await Directory('${project.path}/lib/src/models/order.dart').exists(),
      isTrue,
    );
  });

  test(
    'snake_case and acronym names produce conventional Dart filenames',
    () async {
      final profile = await generateModel(
        project: project,
        name: 'user_profile',
      );
      expect(profile.path, endsWith('user_profile.dart'));
      expect(await profile.readAsString(), contains('class UserProfile'));
      final response = await generateModel(
        project: project,
        name: 'HTTPResponse',
      );
      expect(response.path, endsWith('http_response.dart'));
    },
  );

  test('invalid or core-type names fail before creating output', () async {
    for (final name in [
      '',
      '../escape',
      'a;exit(0)',
      'user-profile',
      'String',
      'DateTime',
      'Map',
    ]) {
      await expectLater(
        generateModel(project: project, name: name),
        throwsFormatException,
      );
    }
    expect(await project.list().toList(), isEmpty);
  });

  test(
    'outside output and file ancestor fail without touching customer data',
    () async {
      for (final output in ['../outside', project.parent.path, '.']) {
        await expectLater(
          generateModel(project: project, name: 'User', output: output),
          throwsFormatException,
        );
      }
      final file = File('${project.path}/lib');
      await file.writeAsString('customer file');
      await expectLater(
        generateModel(project: project, name: 'User'),
        throwsA(isA<FileSystemException>()),
      );
      expect(await file.readAsString(), 'customer file');
    },
  );

  test('linked output directories and target paths are refused', () async {
    final outside = await Directory.systemTemp.createTemp('ds-model-external-');
    try {
      Future<void> directoryLink(String path) async {
        if (Platform.isWindows) {
          final result = await Process.run('cmd', [
            '/c',
            'mklink',
            '/J',
            path.replaceAll('/', '\\'),
            outside.path.replaceAll('/', '\\'),
          ]);
          expect(
            result.exitCode,
            0,
            reason: '${result.stdout}\n${result.stderr}',
          );
        } else {
          await Link(path).create(outside.path);
        }
      }

      await directoryLink('${project.path}/linked');
      await expectLater(
        generateModel(project: project, name: 'User', output: 'linked'),
        throwsA(isA<FileSystemException>()),
      );
      expect(await outside.list().toList(), isEmpty);
      await Directory('${project.path}/lib/src/models').create(recursive: true);
      await directoryLink('${project.path}/lib/src/models/user.dart');
      await expectLater(
        generateModel(project: project, name: 'User'),
        throwsA(isA<FileSystemException>()),
      );
      expect(await outside.list().toList(), isEmpty);
    } finally {
      await outside.delete(recursive: true);
    }
  });

  test(
    'model command rejects missing name and client-only spec without writing',
    () async {
      final runner = createDartStreamCommandRunner(workingDirectory: project);
      for (final args in [
        ['generate', '--type', 'model'],
        [
          'generate',
          '--type',
          'model',
          '--name',
          'User',
          '--spec',
          'ignored.json',
        ],
        ['generate', '--type', 'extension', '--name', 'User'],
      ]) {
        await expectLater(runner.run(args), throwsA(isA<UsageException>()));
      }
      expect(await project.list().toList(), isEmpty);
    },
  );
}
