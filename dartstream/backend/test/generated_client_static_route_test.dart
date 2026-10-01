import 'dart:convert';
import 'dart:io';

import 'package:ds_dartstream/src/cli/generate_openapi_client.dart';
import 'package:test/test.dart';

void main() {
  late Directory project;
  setUp(() async {
    project = await Directory.systemTemp.createTemp('ds-static-route-');
  });
  tearDown(() => project.delete(recursive: true));

  test('invalid static routes fail before output is created', () async {
    for (final path in [
      '/v1/../admin',
      '/v1/./items',
      '/v1/%2e%2e/admin',
      '/v1/%2E/items',
      r'/v1\..\admin',
      '/v1/items?other=route',
      '/v1/items#ignored',
      '/v1/{id',
      '/v1/id}',
      '/v1/{{id}}',
      '/v1/{}',
      '/v1/%invalid',
    ]) {
      final spec = File('${project.path}/spec.json');
      await spec.writeAsString(
        jsonEncode({
          'openapi': '3.0.3',
          'paths': {
            path: {
              'get': {'operationId': 'readItem'},
            },
          },
        }),
      );
      final output = Directory('${project.path}/generated');
      await expectLater(
        generateOpenApiClient(
          specification: spec,
          output: output,
          name: 'catalog',
        ),
        throwsFormatException,
        reason: 'Invalid static route accepted: $path',
      );
      expect(await output.exists(), isFalse);
    }
  });

  test(
    'ordinary placeholders and encoded punctuation stay supported',
    () async {
      final spec = File('${project.path}/spec.json');
      await spec.writeAsString(
        jsonEncode({
          'openapi': '3.0.3',
          'paths': {
            '/v1/items/{item-id}/versions/v1.2': {
              'get': {'operationId': 'readItem'},
            },
            '/v1/literal%3Fvalue%23tag/%252e': {
              'post': {'operationId': 'createItem'},
            },
          },
        }),
      );
      final generated = await generateOpenApiClient(
        specification: spec,
        output: Directory('${project.path}/generated'),
        name: 'catalog',
      );
      final source = await File(
        '${generated.path}/lib/ds_catalog_client.dart',
      ).readAsString();
      expect(source, contains('/v1/items/{item-id}/versions/v1.2'));
      expect(source, contains('/v1/literal%3Fvalue%23tag/%252e'));
      await File('${generated.path}/run.dart').writeAsString('''
import 'package:ds_catalog_client/ds_catalog_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Future<void> main() async {
  final requests = <http.Request>[];
  final client = DSCatalogClient(
    baseUrl: Uri.parse('https://api.example.invalid/base'),
    client: MockClient((request) async {
      requests.add(request);
      return http.Response('preserved', 403);
    }),
  );
  try {
    final first = await client.readItem(
      pathParameters: {'item-id': 'a/b'},
      query: {'q': 'value?with#punctuation'},
    );
    final second = await client.createItem();
    if (requests.length != 2 ||
        requests[0].url.path != '/base/v1/items/a%2Fb/versions/v1.2' ||
        requests[0].url.queryParameters['q'] != 'value?with#punctuation' ||
        requests[1].url.toString() !=
          'https://api.example.invalid/base/v1/literal%3Fvalue%23tag/%252e' ||
        requests.any((request) => request.url.hasFragment) ||
        first.statusCode != 403 || second.body != 'preserved') {
      throw StateError('Static route or response boundary changed.');
    }
  } finally {
    client.close();
  }
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
          workingDirectory: generated.path,
        );
        expect(
          result.exitCode,
          0,
          reason: '${result.stdout}\n${result.stderr}',
        );
      }
    },
  );
}
