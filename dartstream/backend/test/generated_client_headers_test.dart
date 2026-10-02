import 'dart:convert';
import 'dart:io';

import 'package:ds_dartstream/src/cli/generate_openapi_client.dart';
import 'package:test/test.dart';

void main() {
  test(
    'generated headers honor presence, casing, overrides and reserved names',
    () async {
      final temp = Directory.systemTemp.createTempSync('ds-client-headers-');
      try {
        final spec = File('${temp.path}/spec.json')
          ..writeAsStringSync(
            jsonEncode({
              'openapi': '3.0.3',
              'paths': {
                '/items': {
                  'parameters': [
                    {'name': 'X-Tenant', 'in': 'header', 'required': true},
                    {'name': 'X-Optional', 'in': 'header', 'required': true},
                    {'name': r'X-Customer$', 'in': 'header', 'required': true},
                    for (final name in [
                      'Accept',
                      'Content-Type',
                      'Authorization',
                    ])
                      {'name': name, 'in': 'header', 'required': true},
                  ],
                  'get': {
                    'operationId': 'readItems',
                    'parameters': [
                      {'name': 'X-Optional', 'in': 'header', 'required': false},
                      {'name': 'X-Tenant', 'in': 'query', 'required': false},
                    ],
                  },
                  'post': {
                    'operationId': 'saveItem',
                    'parameters': [
                      {'name': 'X-Tenant', 'in': 'header', 'required': false},
                      {'name': 'X-Optional', 'in': 'header', 'required': false},
                      {
                        'name': r'X-Customer$',
                        'in': 'header',
                        'required': false,
                      },
                    ],
                  },
                },
              },
            }),
          );
        final generated = await generateOpenApiClient(
          specification: spec,
          output: Directory('${temp.path}/output'),
          name: 'headers',
        );
        Directory('${generated.path}/bin').createSync();
        File('${generated.path}/bin/probe.dart').writeAsStringSync(r'''
import 'package:ds_headers_client/ds_headers_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
Future<void> main() async {
  final calls = <http.Request>[];
  final client = DSHeadersClient(baseUrl: Uri.parse('https://example.invalid/v1'),
    client: MockClient((request) async { calls.add(request); return http.Response('denied', 403); }));
  try {
    for (final headers in <Map<String, String>>[{}, {'X-Tenant': 'tenant'}, {r'X-Customer$': 'custom'}]) {
      var rejected = false;
      try { await client.readItems(headers: headers, query: {'X-Tenant': 'not-a-header'}); }
      on ArgumentError { rejected = true; }
      if (!rejected || calls.isNotEmpty) throw StateError('Missing header reached transport');
    }
    final response = await client.readItems(headers: {'x-TeNaNt': 'tenant', r'x-customer$': ''});
    if (response.statusCode != 403 || response.body != 'denied' || calls.length != 1 ||
        calls.single.headers['x-tenant'] != 'tenant' || calls.single.headers[r'x-customer$'] != '' ||
        calls.single.headers.containsKey('x-optional') || calls.single.url.path != '/v1/items') {
      throw StateError('Header presence/casing/optional/response contract changed');
    }
    await client.saveItem();
    if (calls.length != 2) throw StateError('Operation override or reserved definition became required');
    print('Headers checked before transport; case-insensitive presence, optional overrides, reserved definitions and 403 pass');
  } finally { client.close(); }
}
''');
        for (final args in [
          ['pub', 'get'],
          ['analyze', '--fatal-infos'],
          ['run', 'bin/probe.dart'],
        ]) {
          final result = await Process.run(
            Platform.resolvedExecutable,
            args,
            workingDirectory: generated.path,
          );
          expect(
            result.exitCode,
            0,
            reason: '${result.stdout}\n${result.stderr}',
          );
        }
      } finally {
        temp.deleteSync(recursive: true);
      }
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
