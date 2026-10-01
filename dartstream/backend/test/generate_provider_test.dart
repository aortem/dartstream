import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ds_dartstream/src/cli/dartstream_cli.dart';
import 'package:ds_dartstream/src/cli/generate_provider.dart';
import 'package:test/test.dart';

void main() {
  late Directory project;
  setUp(() async {
    project = await Directory.systemTemp.createTemp('ds-provider-');
  });
  tearDown(() => project.delete(recursive: true));

  test(
    'documented command generates an independently runnable adapter',
    () async {
      await createDartStreamCommandRunner(
        workingDirectory: project,
      ).run(['generate', '--type', 'provider', '--name', 'Payment']);
      expect(
        File(
          '${project.path}/lib/src/providers/ds_payment_provider.dart',
        ).existsSync(),
        isTrue,
      );
      await File('${project.path}/pubspec.yaml').writeAsString(
        'name: independent_provider\nenvironment: {sdk: ^3.12.2}\n',
      );
      await File('${project.path}/run.dart').writeAsString('''
import 'lib/src/providers/ds_payment_provider.dart';
Future<void> main() async {
  final calls = <String>[];
  final failure = StateError('application denied action');
  final provider = DSPaymentProvider(
    onInitialize: () async { await Future<void>.delayed(Duration.zero); calls.add('initialize'); },
    onDispose: () { calls.add('dispose'); },
    onAction: (action) async {
      if (action == 'denied') throw failure;
      await Future<void>.delayed(Duration.zero);
      calls.add(action);
    },
  );
  await provider.initialize();
  await provider.performAction('real-action');
  var rejected = false;
  try { await provider.performAction('denied'); }
  catch (error) { rejected = identical(error, failure); }
  await provider.dispose();
  if (!rejected || calls.join(',') != 'initialize,real-action,dispose') {
    throw StateError('callbacks were not awaited or failure was hidden');
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

  test(
    'customer output is retained and invalid paths create nothing',
    () async {
      final file = await generateProvider(project: project, name: 'Payment');
      await file.writeAsString('// customer implementation\n');
      await expectLater(
        generateProvider(project: project, name: 'Payment'),
        throwsA(isA<FileSystemException>()),
      );
      expect(await file.readAsString(), '// customer implementation\n');
      for (final output in ['../outside', project.parent.path, '.']) {
        await expectLater(
          generateProvider(project: project, name: 'Other', output: output),
          throwsFormatException,
        );
      }
    },
  );

  test('bad arguments are rejected before writing customer files', () async {
    final runner = createDartStreamCommandRunner(workingDirectory: project);
    for (final arguments in [
      ['generate', '--type', 'provider'],
      ['generate', '--type', 'provider', '--name', '../escape'],
      [
        'generate',
        '--type',
        'provider',
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
    'snake_case names and custom local output use the documented filename',
    () async {
      final file = await generateProvider(
        project: project,
        name: 'payment_gateway',
        output: 'lib/providers',
      );
      expect(file.path, endsWith('ds_payment_gateway_provider.dart'));
      expect(
        await file.readAsString(),
        contains('class DSPaymentGatewayProvider'),
      );
    },
  );
}
