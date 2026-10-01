import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ds_dartstream/src/cli/dartstream_cli.dart';
import 'package:ds_dartstream/src/cli/discover_extensions.dart';
import 'package:ds_dartstream/src/cli/generate_extension.dart';
import 'package:test/test.dart';

void main() {
  late Directory project;
  setUp(() async {
    project = await Directory.systemTemp.createTemp('ds-extension-');
  });
  tearDown(() => project.delete(recursive: true));

  test(
    'generated package resolves, runs lifecycle callbacks and is discoverable',
    () async {
      await createDartStreamCommandRunner(
        workingDirectory: project,
      ).run(['generate', '--type', 'extension', '--name', 'Payment']);
      final package = Directory(
        '${project.path}/packages/ds_payment_extension',
      );
      await File('${package.path}/run.dart').writeAsString('''
import 'package:ds_lifecycle_base/ds_lifecycle_base.dart';
import 'lib/ds_payment_extension.dart';
Future<void> main() async {
  final calls = <String>[];
  final failure = StateError('application denied action');
  final extension = DSPaymentExtension(
    onInitialize: () { calls.add('initialize'); },
    onRegister: () { calls.add('register'); },
    onConfigUpdate: (config) { calls.add(config['value'] as String); },
    onDispose: () { calls.add('dispose'); },
    onExecute: (params) async {
      if (params['denied'] == true) throw failure;
      await Future<void>.delayed(Duration.zero);
      calls.add(params['value'] as String);
    },
  );
  final LifecycleHook lifecycle = extension;
  lifecycle.onRegister();
  lifecycle.onInitialize();
  lifecycle.onConfigUpdate({'value':'updated'});
  await extension.execute({'value':'executed'});
  var rejected = false;
  try { await extension.execute({'denied':true}); }
  catch (error) { rejected = identical(error, failure); }
  lifecycle.onDispose();
  if (!rejected || calls.join(',') != 'register,initialize,updated,executed,dispose') {
    throw StateError('Lifecycle, awaiting or error contract failed');
  }
}
''');
      for (final arguments in [
        ['pub', 'get'],
        ['analyze', '--fatal-infos'],
        ['run', 'run.dart'],
      ]) {
        final result = await Process.run(
          Platform.resolvedExecutable,
          arguments,
          workingDirectory: package.path,
        );
        expect(
          result.exitCode,
          0,
          reason: '${result.stdout}\n${result.stderr}',
        );
      }
      expect(
        discoverExtensions(project, register: false).single['name'],
        'ds_payment_extension',
      );
      expect(Directory('${project.path}/.dartstream').existsSync(), isFalse);
      Directory('${project.path}/.dartstream').createSync();
      final registry = File('${project.path}/.dartstream/extensions.json');
      registry.writeAsStringSync(
        '{"custom":"keep","extensions":[{"name":"ds_payment_extension","enabled":false,"customer":"keep"}]}',
      );
      discoverExtensions(project, register: true);
      final state = jsonDecode(registry.readAsStringSync()) as Map;
      expect(state['custom'], 'keep');
      expect(state['extensions'].single['enabled'], isFalse);
      expect(state['extensions'].single['customer'], 'keep');
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );

  test(
    'custom output and snake_case name create one complete package',
    () async {
      await createDartStreamCommandRunner(workingDirectory: project).run([
        'generate',
        '-t',
        'extension',
        '-n',
        'payment_gateway',
        '--output',
        'packages/local',
      ]);
      final package = Directory(
        '${project.path}/packages/local/ds_payment_gateway_extension',
      );
      expect(File('${package.path}/pubspec.yaml').existsSync(), isTrue);
      expect(
        File(
          '${package.path}/lib/ds_payment_gateway_extension.dart',
        ).readAsStringSync(),
        contains('class DSPaymentGatewayExtension implements LifecycleHook'),
      );
      expect(
        discoverExtensions(project, register: false).single['manifest'],
        'packages/local/ds_payment_gateway_extension/manifest.yaml',
      );
    },
  );

  test('existing directories and invalid paths are preserved', () async {
    final package = await generateExtension(project: project, name: 'Payment');
    final manifest = File('${package.path}/manifest.yaml');
    manifest.writeAsStringSync('customer: keep\n');
    await expectLater(
      generateExtension(project: project, name: 'Payment'),
      throwsA(isA<FileSystemException>()),
    );
    expect(manifest.readAsStringSync(), 'customer: keep\n');
    for (final output in ['../outside', project.parent.path, '.']) {
      await expectLater(
        generateExtension(project: project, name: 'Other', output: output),
        throwsFormatException,
      );
    }
    final fileParent = File('${project.path}/file-parent')
      ..writeAsStringSync('keep');
    await expectLater(
      generateExtension(
        project: project,
        name: 'Other',
        output: 'file-parent/child',
      ),
      throwsA(isA<FileSystemException>()),
    );
    expect(fileParent.readAsStringSync(), 'keep');
  });

  test('invalid flags write nothing', () async {
    final runner = createDartStreamCommandRunner(workingDirectory: project);
    for (final arguments in [
      ['generate', '--type', 'extension'],
      ['generate', '--type', 'extension', '--name', '../outside'],
      [
        'generate',
        '--type',
        'extension',
        '--name',
        'Payment',
        '--spec',
        'spec.json',
      ],
    ]) {
      await expectLater(runner.run(arguments), throwsA(isA<UsageException>()));
      expect(await project.list().toList(), isEmpty);
    }
  });

  test(
    'linked parents and linked package targets never receive writes',
    () async {
      final outside = await Directory.systemTemp.createTemp(
        'ds-extension-outside-',
      );
      Future<void> linkDirectory(String path) async {
        if (Platform.isWindows) {
          final result = await Process.run('cmd', [
            '/c',
            'mklink',
            '/J',
            path.replaceAll('/', '\\'),
            outside.path,
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

      try {
        await linkDirectory('${project.path}/linked');
        await expectLater(
          generateExtension(
            project: project,
            name: 'Payment',
            output: 'linked/child',
          ),
          throwsA(isA<FileSystemException>()),
        );
        await Directory('${project.path}/packages').create();
        await linkDirectory('${project.path}/packages/ds_payment_extension');
        await expectLater(
          generateExtension(project: project, name: 'Payment'),
          throwsA(isA<FileSystemException>()),
        );
        expect(await outside.list().toList(), isEmpty);
      } finally {
        await outside.delete(recursive: true);
      }
    },
  );
}
