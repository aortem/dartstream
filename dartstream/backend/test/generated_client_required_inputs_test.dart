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
    temp = Directory.systemTemp.createTempSync('ds-client-required-');
    spec = File('${temp.path}/spec.json');
  });
  tearDown(() => temp.deleteSync(recursive: true));

  void specification(Map<String, dynamic> path) => spec.writeAsStringSync(
    jsonEncode({
      'openapi': '3.0.3',
      'paths': {'/items': path},
    }),
  );

  test(
    'generated client checks inherited inputs, overrides and body before transport',
    () async {
      specification({
        'parameters': [
          {'name': 'tenant', 'in': 'query', 'required': true},
          {'name': 'page', 'in': 'query', 'required': true},
          {'name': 'same', 'in': 'header', 'required': false},
          {'name': r'customer$"key', 'in': 'query', 'required': true},
        ],
        'post': {
          'operationId': 'saveItem',
          'parameters': [
            {'name': 'page', 'in': 'query', 'required': false},
            {'name': 'same', 'in': 'query', 'required': true},
          ],
          'requestBody': {
            'required': true,
            'content': {'application/json': {}},
          },
        },
        'get': {
          'operationId': 'readItem',
          'parameters': [
            {'name': 'tenant', 'in': 'query', 'required': false},
            {'name': 'page', 'in': 'query', 'required': false},
            {'name': r'customer$"key', 'in': 'query', 'required': false},
          ],
          'requestBody': {
            'required': false,
            'content': {'application/json': {}},
          },
        },
      });
      await createDartStreamCommandRunner(workingDirectory: temp).run([
        'generate',
        '--type',
        'client',
        '--name',
        'required',
        '--spec',
        spec.path,
      ]);
      final directory = Directory(
        '${temp.path}/generated_clients/ds_required_client',
      );
      Directory('${directory.path}/bin').createSync();
      File('${directory.path}/bin/probe.dart').writeAsStringSync(r'''
import 'dart:convert';
import 'package:ds_required_client/ds_required_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Future<void> main() async {
  final calls = <http.Request>[];
  final client = DSRequiredClient(
    baseUrl: Uri.parse('https://example.invalid/v1/'),
    client: MockClient((request) async {
      calls.add(request);
      return http.Response('denied', 403);
    }),
  );
  final values = {'tenant': '', 'same': 'value', r'customer$"key': 'safe'};
  try {
    for (final missing in ['tenant', 'same', r'customer$"key']) {
      final query = Map<String, String>.from(values)..remove(missing);
      var rejected = false;
      try { await client.saveItem(query: query, body: {'id': 1}); }
      on ArgumentError { rejected = true; }
      if (!rejected || calls.isNotEmpty) throw StateError('Missing query reached transport');
    }
    var rejected = false;
    try { await client.saveItem(query: values); }
    on ArgumentError { rejected = true; }
    if (!rejected || calls.isNotEmpty) throw StateError('Missing body reached transport');
    final response = await client.saveItem(query: values, body: {'id': 1});
    if (response.statusCode != 403 || response.body != 'denied' || calls.length != 1 ||
        calls.single.url.path != '/v1/items' ||
        calls.single.url.queryParameters['tenant'] != '' ||
        calls.single.url.queryParameters.containsKey('page') ||
        calls.single.url.queryParameters[r'customer$"key'] != 'safe' ||
        jsonDecode(calls.single.body)['id'] != 1) {
      throw StateError('Supplied input/response contract changed');
    }
    await client.readItem();
    if (calls.length != 2 || calls.last.body.isNotEmpty) {
      throw StateError('Optional override/body became required');
    }
    print('Required inputs fail before transport; overrides, literals, JSON and denial responses pass');
  } finally { client.close(); }
}
''');
      for (final arguments in [
        ['pub', 'get'],
        ['analyze', '--fatal-infos'],
        ['run', 'bin/probe.dart'],
      ]) {
        final result = await Process.run(
          Platform.resolvedExecutable,
          arguments,
          workingDirectory: directory.path,
        );
        expect(
          result.exitCode,
          0,
          reason: '${result.stdout}\n${result.stderr}',
        );
      }
      final library = File('${directory.path}/lib/ds_required_client.dart');
      await library.writeAsString('// customer edit\n');
      await expectLater(
        generateOpenApiClient(
          specification: spec,
          output: directory.parent,
          name: 'required',
        ),
        throwsA(isA<FileSystemException>()),
      );
      expect(await library.readAsString(), '// customer edit\n');
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );

  for (final location in ['path', 'operation']) {
    test('invalid $location parameters fail before output', () async {
      for (final parameters in [
        {},
        [
          {'name': 'tenant', 'in': 'query', 'required': 'true'},
        ],
        [
          {r'$ref': '#/components/parameters/Tenant'},
        ],
        [
          {'name': 'tenant', 'in': 'query'},
          {'name': 'tenant', 'in': 'query'},
        ],
        [
          {'name': '', 'in': 'query'},
        ],
        [
          {'name': 'tenant', 'in': 'invalid'},
        ],
      ]) {
        specification({
          if (location == 'path') 'parameters': parameters,
          'get': {
            'operationId': 'readItem',
            if (location == 'operation') 'parameters': parameters,
          },
        });
        await expectLater(
          generateOpenApiClient(
            specification: spec,
            output: Directory('${temp.path}/output'),
            name: 'invalid',
          ),
          throwsFormatException,
        );
        expect(Directory('${temp.path}/output').existsSync(), isFalse);
      }
    });
  }
  test('referenced or malformed body metadata fails before output', () async {
    for (final body in [
      [],
      {r'$ref': '#/components/requestBodies/Item'},
      {'required': 'true'},
    ]) {
      specification({
        'post': {'operationId': 'saveItem', 'requestBody': body},
      });
      await expectLater(
        generateOpenApiClient(
          specification: spec,
          output: Directory('${temp.path}/output'),
          name: 'invalid',
        ),
        throwsFormatException,
      );
      expect(Directory('${temp.path}/output').existsSync(), isFalse);
    }
  });
  test(
    'CLI reports referenced metadata as a usage error without output',
    () async {
      specification({
        'get': {
          'operationId': 'readItem',
          'parameters': [
            {r'$ref': '#/components/parameters/Tenant'},
          ],
        },
      });
      await expectLater(
        createDartStreamCommandRunner(workingDirectory: temp).run([
          'generate',
          '--type',
          'client',
          '--name',
          'invalid',
          '--spec',
          spec.path,
        ]),
        throwsA(isA<UsageException>()),
      );
      expect(Directory('${temp.path}/generated_clients').existsSync(), isFalse);
    },
  );
}
