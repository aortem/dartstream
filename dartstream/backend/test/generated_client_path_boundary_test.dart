import 'dart:convert';
import 'dart:io';

import 'package:ds_dartstream/src/cli/generate_openapi_client.dart';
import 'package:test/test.dart';

void main() {
  test(
    'generated client rejects dot segments before sending a request',
    () async {
      final temp = Directory.systemTemp.createTempSync(
        'ds-client-path-boundary-',
      );
      try {
        final spec = File('${temp.path}/spec.json')
          ..writeAsStringSync(
            jsonEncode({
              'openapi': '3.0.3',
              'paths': {
                '/projects/{id}': {
                  'get': {'operationId': 'readProject'},
                },
              },
            }),
          );
        final dir = await generateOpenApiClient(
          specification: spec,
          output: Directory('${temp.path}/output'),
          name: 'boundary',
        );
        final get = await Process.run(Platform.resolvedExecutable, [
          'pub',
          'get',
        ], workingDirectory: dir.path);
        expect(get.exitCode, 0, reason: '${get.stdout}\n${get.stderr}');
        Directory('${dir.path}/bin').createSync();
        File('${dir.path}/bin/probe.dart').writeAsStringSync(r'''
import 'package:ds_boundary_client/ds_boundary_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Future<void> main() async {
  final calls = <Uri>[];
  final client = DSBoundaryClient(
    baseUrl: Uri.parse('https://example.invalid/v1/'),
    client: MockClient((request) async {
      calls.add(request.url);
      return http.Response('ok', 200);
    }),
  );
  try {
    for (final value in ['.', '..']) {
      var rejected = false;
      try {
        await client.readProject(pathParameters: {'id': value},
            headers: {'Authorization': 'Bearer disposable'});
      } on ArgumentError { rejected = true; }
      if (!rejected || calls.isNotEmpty) {
        throw StateError('Dot-segment parameter reached transport: $value $calls');
      }
    }
    for (final value in ['customer/id', 'customer..id', '%2e%2e']) {
      await client.readProject(pathParameters: {'id': value});
      if (calls.last.pathSegments.length != 3 ||
          calls.last.pathSegments.last != value ||
          calls.last.pathSegments.first != 'v1') {
        throw StateError('Normal parameter lost its route boundary: ${calls.last}');
      }
    }
    print('Dot segments blocked; ordinary, slash and encoded-looking IDs preserved');
  } finally { client.close(); }
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
        final probe = await Process.run(Platform.resolvedExecutable, [
          'run',
          'bin/probe.dart',
        ], workingDirectory: dir.path);
        expect(probe.exitCode, 0, reason: '${probe.stdout}\n${probe.stderr}');
      } finally {
        temp.deleteSync(recursive: true);
      }
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
