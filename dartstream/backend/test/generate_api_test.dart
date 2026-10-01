import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ds_dartstream/src/cli/dartstream_cli.dart';
import 'package:ds_dartstream/src/cli/generate_api.dart';
import 'package:test/test.dart';

void main() {
  late Directory project;
  setUp(() async {
    project = await Directory.systemTemp.createTemp('ds-api-');
    await File('${project.path}/pubspec.yaml').writeAsString('''
name: independent_api
environment: {sdk: ^3.12.2}
dependencies:
  shelf: ^1.4.2
  shelf_router: ^1.1.4
''');
  });
  tearDown(() => project.delete(recursive: true));

  test('documented command generates runnable real HTTP routes', () async {
    await createDartStreamCommandRunner(workingDirectory: project)
        .run(['generate', '--type', 'api', '--name', 'Product']);
    expect(
      await File('${project.path}/lib/src/api/product_api.dart').exists(),
      isTrue,
    );
    await File('${project.path}/run.dart').writeAsString('''
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'lib/src/api/product_api.dart';

void check(bool value) { if (!value) throw StateError('route contract failed'); }
Future<void> main() async {
  final calls = <String>[];
  final api = ProductApi(
    list: (r) { calls.add('list'); return Response.ok('actual list'); },
    create: (r) async {
      calls.add('create');
      return Response(201, body: await r.readAsString(), headers: {'x-app': 'create'});
    },
    get: (r, id) { calls.add('get:\$id'); return Response(404, body: 'missing:\$id'); },
    update: (r, id) async {
      calls.add('update:\$id');
      return Response(409, body: await r.readAsString());
    },
    delete: (r, id) { calls.add('delete:\$id'); return Response.forbidden('denied:\$id'); },
  );
  final server = await serve(api.handler, InternetAddress.loopbackIPv4, 0);
  final client = HttpClient();
  try {
    Future<void> request(String method, String path, int status, String body,
        {String? input, String? appHeader}) async {
      final req = await client.openUrl(method, Uri.parse('http://127.0.0.1:\${server.port}\$path'));
      if (input != null) req.write(input);
      final res = await req.close();
      final text = await res.transform(SystemEncoding().decoder).join();
      check(res.statusCode == status && text == body);
      if (appHeader != null) check(res.headers.value('x-app') == appHeader);
    }
    await request('GET', '/', 200, 'actual list');
    await request('POST', '/', 201, 'payload', input: 'payload', appHeader: 'create');
    await request('GET', '/sku-7', 404, 'missing:sku-7');
    await request('PUT', '/sku-8', 409, 'edited', input: 'edited');
    await request('DELETE', '/sku-9', 403, 'denied:sku-9');
    final count = calls.length;
    final unknown = await api.handler(Request('GET', Uri.parse('http://localhost/a/b')));
    check(unknown.statusCode == 404 && calls.length == count);
    final unsupported = await api.handler(Request('PATCH', Uri.parse('http://localhost/sku-7')));
    check(unsupported.statusCode == 404 && calls.length == count);
    check(calls.join(',') == 'list,create,get:sku-7,update:sku-8,delete:sku-9');
  } finally {
    client.close(force: true);
    await server.close(force: true);
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
        workingDirectory: project.path,
      );
      expect(result.exitCode, 0, reason: '${result.stdout}\n${result.stderr}');
    }
  }, timeout: const Timeout(Duration(minutes: 3)));

  test('customer source and manifest remain untouched on repeat', () async {
    final manifest = File('${project.path}/pubspec.yaml');
    final before = await manifest.readAsString();
    final api = await generateApi(project: project, name: 'Product');
    await api.writeAsString('// customer edited\n');
    await expectLater(
      generateApi(project: project, name: 'Product'),
      throwsA(isA<FileSystemException>()),
    );
    expect(await api.readAsString(), '// customer edited\n');
    expect(await manifest.readAsString(), before);
  });

  test('missing direct dependencies fail before any generated write', () async {
    final manifest = File('${project.path}/pubspec.yaml');
    await manifest.writeAsString(
      'name: customer\ndependencies: {shelf: ^1.4.2}\n',
    );
    final before = await manifest.readAsString();
    await expectLater(
      generateApi(project: project, name: 'Product'),
      throwsFormatException,
    );
    expect(await manifest.readAsString(), before);
    expect(await project.list().length, 1);
  });

  test(
    'invalid names, missing name and client spec fail without output',
    () async {
      for (final name in [
        '',
        '../escape',
        'a;exit(0)',
        'product-api',
        'String',
      ]) {
        await expectLater(
          generateApi(project: project, name: name),
          throwsFormatException,
        );
      }
      final runner = createDartStreamCommandRunner(workingDirectory: project);
      for (final args in [
        ['generate', '--type', 'api'],
        [
          'generate',
          '--type',
          'api',
          '--name',
          'Product',
          '--spec',
          'ignored.json',
        ],
      ]) {
        await expectLater(runner.run(args), throwsA(isA<UsageException>()));
      }
      expect(await project.list().length, 1);
    },
  );

  test(
    'in-project custom output and names follow model naming rules',
    () async {
      final file = await generateApi(
        project: project,
        name: 'product_catalog',
        output: 'lib/routes',
      );
      expect(file.path, endsWith('product_catalog_api.dart'));
      expect(await file.readAsString(), contains('class ProductCatalogApi'));
      final acronym = await generateApi(project: project, name: 'HTTPResponse');
      expect(acronym.path, endsWith('http_response_api.dart'));
    },
  );

  test(
    'outside output, file ancestors and existing targets are refused',
    () async {
      for (final output in ['../outside', project.parent.path, '.']) {
        await expectLater(
          generateApi(project: project, name: 'Product', output: output),
          throwsFormatException,
        );
      }
      final ancestor = File('${project.path}/lib');
      await ancestor.writeAsString('customer');
      await expectLater(
        generateApi(project: project, name: 'Product'),
        throwsA(isA<FileSystemException>()),
      );
      expect(await ancestor.readAsString(), 'customer');
    },
  );
}
