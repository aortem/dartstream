import 'dart:convert';
import 'dart:io';

import 'package:ds_dartstream/src/cli/cli_session.dart';
import 'package:ds_dartstream/src/cli/dartstream_cli.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  late Directory dir;
  late HttpServer server;
  late Uri tokenUrl, projectsUrl;
  var requests = 0;
  final observedSecrets = <String>[];

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('cli_empty_148_');
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    tokenUrl = Uri.parse('http://127.0.0.1:${server.port}/token');
    projectsUrl = Uri.parse('http://127.0.0.1:${server.port}/projects');
    requests = 0;
    observedSecrets.clear();
    server.listen((request) async {
      requests++;
      request.response.headers.contentType = ContentType.json;
      if (request.uri.path == '/token') {
        final body = jsonDecode(await utf8.decoder.bind(request).join());
        observedSecrets.add(body['client_secret'] as String);
        if (body['client_secret'] != 'valid-fixture') {
          request.response.statusCode = 401;
          request.response.write('{"error":"invalid_client"}');
        } else {
          final claims = base64Url.encode(
            utf8.encode(
              jsonEncode({
                'tenantId': 'tenant-fixture',
                'sub': 'client-fixture',
              }),
            ),
          );
          request.response.write(
            jsonEncode({
              'access_token': 'header.$claims.signature',
              'expires_in': 300,
            }),
          );
        }
      } else {
        request.response.write('{"projects":[{"id":"project-fixture"}]}');
      }
      await request.response.close();
    });
  });
  tearDown(() async {
    await server.close(force: true);
    dir.deleteSync(recursive: true);
  });

  CliSession session(Map<String, String> env) => CliSession(
    directory: dir,
    environment: env,
    billingOverride: tokenUrl,
    platformOverride: projectsUrl,
  );
  Matcher emptySecret(String source) => throwsA(
    isA<ArgumentError>().having(
      (e) => e.message,
      'precise local error',
      '$source is empty.',
    ),
  );

  test('empty primary CI secret permits the existing nonempty alias', () async {
    await session({
      'DARTSTREAM_CLIENT_ID': 'client-fixture',
      'DARTSTREAM_CLIENT_SECRET': '',
      'DARTSTREAM_TOKEN': 'valid-fixture',
    }).validateProject('project-fixture');
    expect(observedSecrets, ['valid-fixture']);
    expect(requests, 2);
    expect(File('${dir.path}/credentials.json').existsSync(), isFalse);
  });

  test('nonempty primary secret still takes precedence over alias', () async {
    await session({
      'DARTSTREAM_CLIENT_ID': 'client-fixture',
      'DARTSTREAM_CLIENT_SECRET': 'valid-fixture',
      'DARTSTREAM_TOKEN': 'wrong-fixture',
    }).validateProject('project-fixture');
    expect(observedSecrets, ['valid-fixture']);
  });

  for (final env in [
    {'DARTSTREAM_CLIENT_SECRET': ''},
    {'DARTSTREAM_TOKEN': ''},
    {'DARTSTREAM_CLIENT_SECRET': '', 'DARTSTREAM_TOKEN': ''},
  ]) {
    test(
      'empty CI credential fails locally for ${env.keys.join(',')}',
      () async {
        await expectLater(
          session({
            'DARTSTREAM_CLIENT_ID': 'client-fixture',
            ...env,
          }).validateProject('project-fixture'),
          emptySecret(env.containsKey('DARTSTREAM_TOKEN')
              ? 'DARTSTREAM_TOKEN' : 'DARTSTREAM_CLIENT_SECRET'),
        );
        expect(requests, 0);
        expect(dir.listSync(), isEmpty);
      },
    );
  }

  test('saved empty secret cannot reach the token endpoint', () async {
    final file = File('${dir.path}/credentials.json')
      ..writeAsStringSync(
        jsonEncode({
          'clientId': 'client-fixture',
          'clientSecret': '',
          'environment': 'dev',
        }),
      );
    final before = file.readAsBytesSync();
    await expectLater(
      session({}).validateProject('project-fixture'),
      emptySecret('Saved CLI clientSecret'),
    );
    expect(requests, 0);
    expect(file.readAsBytesSync(), before);
  });

  test(
    'explicit empty login secret never uses an ambient alias or writes',
    () async {
      await expectLater(
        session({
          'DARTSTREAM_TOKEN': 'valid-fixture',
        }).login(clientId: 'client-fixture', secret: ''),
        emptySecret('--token'),
      );
      expect(requests, 0);
      expect(dir.listSync(), isEmpty);
    },
  );

  test(
    'login uses a nonempty alias when the primary environment value is empty',
    () async {
      await session({
        'DARTSTREAM_CLIENT_ID': 'client-fixture',
        'DARTSTREAM_CLIENT_SECRET': '',
        'DARTSTREAM_TOKEN': 'valid-fixture',
      }).login();
      expect(observedSecrets, ['valid-fixture']);
      expect(File('${dir.path}/credentials.json').existsSync(), isTrue);
    },
  );

  for (final command in ['login', 'validate']) {
    for (final source in ['DARTSTREAM_CLIENT_SECRET', 'DARTSTREAM_TOKEN']) {
      test('$command empty $source is a real CLI usage error', () async {
        final result = await Process.run(Platform.resolvedExecutable, [
          'bin/dartstream.dart', command,
          if (command == 'validate') ...['--project', 'project-fixture'],
        ], environment: {
          for (final name in ['SystemRoot', 'TEMP', 'TMP'])
            if (Platform.environment[name] != null)
              name: Platform.environment[name]!,
          'DARTSTREAM_CONFIG_DIR': dir.path,
          'DARTSTREAM_CLIENT_ID': 'client-fixture',
          source: '',
        }, includeParentEnvironment: false);
        expect(result.exitCode, 64);
        expect(result.stderr, contains('$source is empty.'));
        expect(result.stderr, isNot(contains('unexpected error')));
        expect(dir.listSync(), isEmpty);
        expect(requests, 0);
      });
    }
  }

  test('explicit empty --token names the flag and exits 64', () async {
    final result = await Process.run(Platform.resolvedExecutable, [
      'bin/dartstream.dart', 'login', '--client-id', 'client-fixture', '--token=',
    ], environment: {
      for (final name in ['SystemRoot', 'TEMP', 'TMP'])
        if (Platform.environment[name] != null)
          name: Platform.environment[name]!,
      'DARTSTREAM_CONFIG_DIR': dir.path,
      'DARTSTREAM_TOKEN': 'unused-fixture-secret',
    }, includeParentEnvironment: false);
    expect(result.exitCode, 64);
    expect(result.stderr, contains('--token is empty.'));
    expect(result.stderr, isNot(contains('unused-fixture-secret')));
    expect(result.stderr, isNot(contains('DARTSTREAM_CLIENT_SECRET is empty')));
    expect(dir.listSync(), isEmpty);
    expect(requests, 0);
  });

  test(
    'init emits the accepted published dependency and preserves customer edits',
    () async {
      final runner = createDartStreamCommandRunner(workingDirectory: dir);
      await runner.run(['init', '--name', 'fixture_app']);
      final file = File('${dir.path}/pubspec.yaml');
      expect(
        (loadYaml(file.readAsStringSync())
            as YamlMap)['dependencies']['ds_dartstream'],
        '^0.0.12',
      );
      file.writeAsStringSync('# customer retained\n${file.readAsStringSync()}');
      final before = file.readAsStringSync();
      await runner.run(['init', '--name', 'fixture_app']);
      expect(file.readAsStringSync(), before);
    },
  );
}
