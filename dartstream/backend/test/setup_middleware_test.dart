import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ds_dartstream/src/cli/dartstream_cli.dart';
import 'package:test/test.dart';

void main() {
  late Directory project;
  setUp(() async {
    project = await Directory.systemTemp.createTemp('ds-middleware-');
  });
  tearDown(() => project.delete(recursive: true));

  Future<void> manifest({bool shelf = true}) async {
    await File('${project.path}/pubspec.yaml').writeAsString('''
name: customer
environment:
  sdk: ^3.12.2
${shelf ? 'dependencies:\n  shelf: ^1.4.2' : ''}
''');
  }

  test(
    'setup generates middleware without changing customer CI or config',
    () async {
      await manifest();
      final ci = File('${project.path}/.gitlab-ci.yml')
        ..writeAsStringSync('# customer CI\n');
      final config = File('${project.path}/dartstream.yaml')
        ..writeAsStringSync('# customer config\n');
      final before = File('${project.path}/pubspec.yaml').readAsStringSync();
      await createDartStreamCommandRunner(
        workingDirectory: project,
      ).run(['setup', '--middleware']);
      expect(
        File(
          '${project.path}/lib/src/middleware/dartstream_middleware.dart',
        ).existsSync(),
        isTrue,
      );
      expect(ci.readAsStringSync(), '# customer CI\n');
      expect(config.readAsStringSync(), '# customer config\n');
      expect(File('${project.path}/pubspec.yaml').readAsStringSync(), before);
    },
  );

  test(
    'generated adapter resolves and preserves actual Shelf behavior',
    () async {
      await manifest();
      await createDartStreamCommandRunner(
        workingDirectory: project,
      ).run(['setup', '--middleware']);
      await File('${project.path}/run.dart').writeAsString(r'''
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'lib/src/middleware/dartstream_middleware.dart';

void check(bool value) { if (!value) throw StateError('middleware contract'); }
Future<void> main() async {
  final events = <String>[];
  Middleware layer(String name) => (inner) => (request) async {
    events.add('before-$name');
    final response = await inner(request);
    events.add('after-$name');
    return response;
  };
  Middleware authenticate = (inner) => (request) async {
    if (request.headers['authorization'] != 'Bearer fixture') {
      return Response.forbidden('denied');
    }
    return inner(request.change(context: {'principal': 'customer'}));
  };
  var reached = 0;
  final handler = withDartStreamMiddleware(
    handler: (request) async {
      reached++;
      check(request.context['principal'] == 'customer');
      return Response.ok(await request.readAsString());
    },
    middleware: [layer('outer'), authenticate, layer('inner')],
  );
  final server = await serve(handler, InternetAddress.loopbackIPv4, 0);
  final client = HttpClient();
  try {
    for (final authorized in [false, true]) {
      events.clear();
      final request = await client.postUrl(Uri.parse('http://127.0.0.1:${server.port}/'));
      if (authorized) request.headers.set('authorization', 'Bearer fixture');
      request.write('body survives middleware');
      final response = await request.close();
      final body = await response.transform(SystemEncoding().decoder).join();
      check(response.statusCode == (authorized ? 200 : 403));
      check(body == (authorized ? 'body survives middleware' : 'denied'));
      check(events.join(',') == (authorized
        ? 'before-outer,before-inner,after-inner,after-outer'
        : 'before-outer,after-outer'));
      check(reached == (authorized ? 1 : 0));
    }
  } finally {
    client.close(force: true);
    await server.close(force: true);
  }
  final failure = StateError('application error');
  final failing = withDartStreamMiddleware(
    handler: (request) async => throw failure,
    middleware: [layer('outer')],
  );
  var propagated = false;
  try { await failing(Request('GET', Uri.parse('http://localhost/'))); }
  catch (error) { propagated = identical(error, failure); }
  check(propagated);
  final empty = withDartStreamMiddleware(handler: (r) => Response(418), middleware: []);
  check((await empty(Request('GET', Uri.parse('http://localhost/')))).statusCode == 418);
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

  test('repeat refuses to overwrite customer middleware', () async {
    await manifest();
    final runner = createDartStreamCommandRunner(workingDirectory: project);
    await runner.run(['setup', '--middleware']);
    final target = File(
      '${project.path}/lib/src/middleware/dartstream_middleware.dart',
    )..writeAsStringSync('// customer edited\n');
    await expectLater(
      runner.run(['setup', '--middleware']),
      throwsA(isA<UsageException>()),
    );
    expect(target.readAsStringSync(), '// customer edited\n');
    expect(File('${project.path}/.gitlab-ci.yml').existsSync(), isFalse);
  });

  test(
    'missing direct dependency and unsupported features write nothing',
    () async {
      final runner = createDartStreamCommandRunner(workingDirectory: project);
      await expectLater(
        runner.run(['setup', '--middleware']),
        throwsA(isA<UsageException>()),
      );
      expect(await project.list().toList(), isEmpty);
      await manifest(shelf: false);
      await expectLater(
        runner.run(['setup', '--middleware']),
        throwsA(isA<UsageException>()),
      );
      expect(Directory('${project.path}/lib').existsSync(), isFalse);
      await manifest();
      for (final extra in [
        ['--features', 'security'],
        ['--saas'],
        ['--name', 'customer'],
      ]) {
        await expectLater(
          runner.run(['setup', '--middleware', ...extra]),
          throwsA(isA<UsageException>()),
        );
        expect(Directory('${project.path}/lib').existsSync(), isFalse);
        expect(File('${project.path}/.gitlab-ci.yml').existsSync(), isFalse);
      }
    },
  );

  test('linked output parent receives no writes', () async {
    await manifest();
    final outside = await Directory.systemTemp.createTemp(
      'ds-middleware-outside-',
    );
    try {
      final linked = '${project.path}/lib';
      if (Platform.isWindows) {
        final result = await Process.run('cmd', [
          '/c',
          'mklink',
          '/J',
          linked.replaceAll('/', '\\'),
          outside.path,
        ]);
        expect(
          result.exitCode,
          0,
          reason: '${result.stdout}\n${result.stderr}',
        );
      } else {
        await Link(linked).create(outside.path);
      }
      await expectLater(
        createDartStreamCommandRunner(
          workingDirectory: project,
        ).run(['setup', '--middleware']),
        throwsA(isA<UsageException>()),
      );
      expect(await outside.list().toList(), isEmpty);
    } finally {
      await outside.delete(recursive: true);
    }
  });
}
