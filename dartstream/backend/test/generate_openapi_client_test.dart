import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ds_dartstream/src/cli/dartstream_cli.dart';
import 'package:ds_dartstream/src/cli/generate_openapi_client.dart';
import 'package:test/test.dart';

void main() {
  late Directory temp;
  late File spec;
  setUp(() {
    temp = Directory.systemTemp.createTempSync('ds-client-generator-');
    spec = File('${temp.path}/openapi.json')
      ..writeAsStringSync(
        jsonEncode({
          'openapi': '3.0.3',
          'paths': {
            '/projects/{id}': {
              'parameters': [],
              'get': {'operationId': 'readProject'},
              'post': {'operationId': 'saveProject'},
            },
          },
        }),
      );
  });
  tearDown(() => temp.deleteSync(recursive: true));

  for (final name in ['demo_', 'demo__client']) {
    test(
      'empty client name words in $name are rejected without output',
      () async {
        await expectLater(
          generateOpenApiClient(
            specification: spec,
            output: Directory('${temp.path}/output'),
            name: name,
          ),
          throwsFormatException,
        );
        expect(Directory('${temp.path}/output').existsSync(), isFalse);
      },
    );
  }

  test('CLI reports invalid client names without a crash or output', () async {
    await expectLater(
      createDartStreamCommandRunner(workingDirectory: temp).run([
        'generate',
        '--type',
        'client',
        '--name',
        'demo_',
        '--spec',
        spec.path,
      ]),
      throwsA(isA<UsageException>()),
    );
    expect(Directory('${temp.path}/generated_clients').existsSync(), isFalse);
  });

  test('multiword client names generate matching Dart identifiers', () async {
    final dir = await generateOpenApiClient(
      specification: spec,
      output: Directory('${temp.path}/output'),
      name: 'demo_api_2',
    );
    expect(dir.path, endsWith('ds_demo_api_2_client'));
    expect(
      File('${dir.path}/lib/ds_demo_api_2_client.dart').readAsStringSync(),
      contains('class DSDemoApi2Client'),
    );
  });

  for (final nested in [false, true]) {
    test(
      'linked output ${nested ? 'ancestor' : 'directory'} is preserved',
      () async {
        final outside = Directory.systemTemp.createTempSync(
          'ds-client-outside-',
        );
        final link = Link('${temp.path}/redirect');
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
        final sentinel = File('${outside.path}/customer.txt')
          ..writeAsStringSync('preserved');
        try {
          await expectLater(
            generateOpenApiClient(
              specification: spec,
              output: Directory('${link.path}${nested ? '/new_output' : ''}'),
              name: 'demo',
            ),
            throwsA(isA<FileSystemException>()),
          );
          expect(sentinel.readAsStringSync(), 'preserved');
          expect(outside.listSync().length, 1);
        } finally {
          link.deleteSync();
          outside.deleteSync(recursive: true);
        }
      },
    );
  }

  test(
    'CLI generates real HTTP calls and preserves existing package',
    () async {
      final runner = createDartStreamCommandRunner(workingDirectory: temp);
      await runner.run([
        'generate',
        '--type',
        'client',
        '--name',
        'demo',
        '--spec',
        spec.path,
      ]);
      final file = File(
        '${temp.path}/generated_clients/ds_demo_client/lib/ds_demo_client.dart',
      );
      final generated = file.readAsStringSync();
      expect(generated, contains('Future<http.Response> readProject'));
      expect(generated, contains('_client.send(request)'));
      file.writeAsStringSync('// customer customization');
      await expectLater(
        runner.run([
          'generate',
          '--type',
          'client',
          '--name',
          'demo',
          '--spec',
          spec.path,
        ]),
        throwsException,
      );
      expect(file.readAsStringSync(), '// customer customization');
    },
  );

  test(
    'invalid upstream identifiers and references never create output',
    () async {
      for (final operation in [
        'close',
        'return',
        'a; inject()',
        'class',
        'toString',
      ]) {
        spec.writeAsStringSync(
          jsonEncode({
            'openapi': '3.0.3',
            'paths': {
              '/': {
                'get': {'operationId': operation},
              },
            },
          }),
        );
        await expectLater(
          generateOpenApiClient(
            specification: spec,
            output: Directory('${temp.path}/output'),
            name: 'demo',
          ),
          throwsFormatException,
        );
        expect(Directory('${temp.path}/output').existsSync(), isFalse);
      }
      spec.writeAsStringSync(
        jsonEncode({
          'openapi': '3.0.3',
          'paths': {
            '/': {r'$ref': 'external.json'},
          },
        }),
      );
      await expectLater(
        generateOpenApiClient(
          specification: spec,
          output: Directory('${temp.path}/output'),
          name: 'demo',
        ),
        throwsFormatException,
      );
    },
  );

  test('quotes and dollar signs in paths are inert data', () async {
    spec.writeAsStringSync(
      jsonEncode({
        'openapi': '3.0.3',
        'paths': {
          r'/price/$value"': {
            'get': {'operationId': 'readPrice'},
          },
        },
      }),
    );
    final dir = await generateOpenApiClient(
      specification: spec,
      output: Directory('${temp.path}/output'),
      name: 'demo',
    );
    expect(
      File('${dir.path}/lib/ds_demo_client.dart').readAsStringSync(),
      contains(r'\$value\"'),
    );
  });

  test(
    'generated package compiles and sends authenticated HTTP requests',
    () async {
      final dir = await generateOpenApiClient(
        specification: spec,
        output: Directory('${temp.path}/output'),
        name: 'demo',
      );
      final get = await Process.run(Platform.resolvedExecutable, [
        'pub',
        'get',
      ], workingDirectory: dir.path);
      expect(get.exitCode, 0, reason: '${get.stdout}\n${get.stderr}');
      await Directory('${dir.path}/bin').create();
      await File('${dir.path}/bin/probe.dart').writeAsString(r'''
import 'dart:convert';
import 'dart:io';
import 'package:ds_demo_client/ds_demo_client.dart';
Future<void> main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  final calls = <String>[];
  final sub = server.listen((request) async {
    calls.add(request.method);
    if (request.uri.pathSegments.last != 'customer/id' ||
        request.uri.queryParameters['filter'] != 'a b&c') {
      throw StateError('Path/query encoding failed: ${request.uri}');
    }
    if (request.headers.value('authorization') != 'Bearer disposable') {
      request.response.statusCode = 403;
    } else if (request.method == 'POST') {
      final body = jsonDecode(await utf8.decoder.bind(request).join());
      if (body['value'] != 42) throw StateError('JSON body was lost');
      request.response.statusCode = 201;
    } else {
      request.response.statusCode = 200;
    }
    request.response.write('response');
    await request.response.close();
  });
  final client = DSDemoClient(baseUrl: Uri.parse('http://127.0.0.1:${server.port}/v1/'));
  try {
    final path = {'id':'customer/id'};
    final query = {'filter':'a b&c'};
    final denied = await client.readProject(pathParameters:path, query:query);
    final read = await client.readProject(pathParameters:path, query:query,
        headers:{'Authorization':'Bearer disposable'});
    final write = await client.saveProject(pathParameters:path, query:query,
        headers:{'Authorization':'Bearer disposable'}, body:{'value':42});
    if (denied.statusCode != 403 || read.statusCode != 200 || write.statusCode != 201 ||
        calls.join(',') != 'GET,GET,POST') throw StateError('HTTP status or method lost');
    var failed = false;
    try { await client.readProject(); } on ArgumentError { failed = true; }
    if (!failed || calls.length != 3) throw StateError('Missing path parameter reached server');
    print('GET/POST, encoded paths/query, JSON, bearer auth and 403 preservation pass');
  } finally {
    client.close();
    await sub.cancel();
    await server.close(force:true);
  }
}
''');
      final analyze = await Process.run(Platform.resolvedExecutable, [
        'analyze',
      ], workingDirectory: dir.path);
      expect(
        analyze.exitCode,
        0,
        reason: '${analyze.stdout}\n${analyze.stderr}',
      );
      final run = await Process.run(Platform.resolvedExecutable, [
        'run',
        'bin/probe.dart',
      ], workingDirectory: dir.path);
      expect(run.exitCode, 0, reason: '${run.stdout}\n${run.stderr}');
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
