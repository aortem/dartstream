import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ds_dartstream/src/cli/dartstream_cli.dart';
import 'package:ds_dartstream/src/cli/generate_scaffold.dart';
import 'package:test/test.dart';

void main() {
  late Directory project;
  setUp(() async {
    project = await Directory.systemTemp.createTemp('ds-scaffold-');
  });
  tearDown(() => project.delete(recursive: true));

  test(
    'independent generated package resolves and serves actual CRUD handlers',
    () async {
      final manifest = File('${project.path}/pubspec.yaml')
        ..writeAsStringSync('name: customer\n');
      await createDartStreamCommandRunner(
        workingDirectory: project,
      ).run(['generate', '--type', 'scaffold', '--name', 'Product']);
      expect(manifest.readAsStringSync(), 'name: customer\n');
      final package = Directory('${project.path}/packages/ds_product_scaffold');
      await File('${package.path}/run.dart').writeAsString('''
import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:ds_product_scaffold/ds_product_scaffold.dart';

void check(bool value) { if (!value) throw StateError('CRUD contract failed'); }
Future<void> main() async {
  final stored = <String, Product>{};
  final now = DateTime.utc(2026, 10, 1);
  Product parse(String body) => Product.fromJson(jsonDecode(body) as Map<String, dynamic>);
  Response json(Object value, {int status = 200}) => Response(status,
    body: jsonEncode(value), headers: {'content-type': 'application/json'});
  final api = ProductApi(
    list: (r) => json(stored.values.map((p) => p.toJson()).toList()),
    create: (r) async {
      final item = parse(await r.readAsString());
      if (stored.containsKey(item.id)) return Response(409, body: 'duplicate');
      stored[item.id] = item;
      return json(item.toJson(), status: 201);
    },
    get: (r, id) => stored.containsKey(id) ? json(stored[id]!.toJson()) : Response.notFound('missing'),
    update: (r, id) async {
      if (!stored.containsKey(id)) return Response.notFound('missing');
      final item = parse(await r.readAsString());
      if (item.id != id) return Response(409, body: 'id conflict');
      stored[id] = item;
      return json(item.toJson());
    },
    delete: (r, id) {
      if (r.headers['x-allow-delete'] != 'yes') return Response.forbidden('denied');
      if (stored.remove(id) == null) return Response.notFound('missing');
      return Response(204);
    },
  );
  final server = await serve(api.handler, InternetAddress.loopbackIPv4, 0);
  final client = HttpClient();
  try {
    Future<String> request(String method, String path, int status, {Product? item, bool allow = false}) async {
      final req = await client.openUrl(method, Uri.parse('http://127.0.0.1:\${server.port}\$path'));
      if (allow) req.headers.set('x-allow-delete', 'yes');
      if (item != null) req.write(jsonEncode(item.toJson()));
      final res = await req.close();
      check(res.statusCode == status);
      return res.transform(SystemEncoding().decoder).join();
    }
    final original = Product(id: 'p-1', name: 'first', createdAt: now);
    final created = parse(await request('POST', '/', 201, item: original));
    check(created == original && created.hashCode == original.hashCode && created.updatedAt == null);
    check(jsonDecode(await request('GET', '/', 200)).length == 1);
    check(parse(await request('GET', '/p-1', 200)).name == 'first');
    await request('POST', '/', 409, item: original);
    final edited = original.copyWith(name: 'edited', updatedAt: now.add(Duration(seconds: 1)));
    final result = parse(await request('PUT', '/p-1', 200, item: edited));
    check(result.name == 'edited' && result.createdAt == now && result.updatedAt == edited.updatedAt);
    await request('PUT', '/p-1', 409, item: edited.copyWith(id: 'other'));
    await request('DELETE', '/p-1', 403);
    check(stored.containsKey('p-1'));
    await request('DELETE', '/p-1', 204, allow: true);
    await request('GET', '/p-1', 404);
    await request('GET', '/nested/path', 404);
    await request('PATCH', '/p-1', 404);
    check(stored.isEmpty);
  } finally {
    client.close(force: true);
    await server.close(force: true);
  }
  final failure = StateError('application failure');
  final rejected = ProductApi(list: (r) async => throw failure,
    create: (r) => Response(409), get: (r, id) => Response(404),
    update: (r, id) => Response(409), delete: (r, id) => Response(403));
  var propagated = false;
  try { await rejected.handler(Request('GET', Uri.parse('http://localhost/'))); }
  catch (error) { propagated = identical(error, failure); }
  check(propagated);
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
          workingDirectory: package.path,
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
    'repeat preserves complete customer package and original manifest',
    () async {
      final package = await generateScaffold(project: project, name: 'Product');
      final model = File('${package.path}/lib/src/product.dart')
        ..writeAsStringSync('// edited\n');
      Map<String, String> snapshot() => {
        for (final f in project.listSync(recursive: true).whereType<File>())
          f.path: f.readAsStringSync(),
      };
      final before = snapshot();
      await expectLater(
        generateScaffold(project: project, name: 'Product'),
        throwsA(isA<FileSystemException>()),
      );
      expect(snapshot(), before);
      expect(model.readAsStringSync(), '// edited\n');
    },
  );

  test('invalid flags and names do not write files', () async {
    final runner = createDartStreamCommandRunner(workingDirectory: project);
    for (final args in [
      ['generate', '--type', 'scaffold'],
      ['generate', '--type', 'scaffold', '--name', '../escape'],
      ['generate', '--type', 'scaffold', '--name', 'String'],
      [
        'generate',
        '--type',
        'scaffold',
        '--name',
        'Product',
        '--spec',
        'ignored.json',
      ],
    ]) {
      await expectLater(runner.run(args), throwsA(isA<UsageException>()));
      expect(await project.list().toList(), isEmpty);
    }
  });

  test(
    'custom names and in-project output work; escapes and files are refused',
    () async {
      for (final output in ['../outside', project.parent.path, '.']) {
        await expectLater(
          generateScaffold(project: project, name: 'Product', output: output),
          throwsFormatException,
        );
        expect(await project.list().toList(), isEmpty);
      }
      final parent = File('${project.path}/blocked')..writeAsStringSync('keep');
      await expectLater(
        generateScaffold(
          project: project,
          name: 'Product',
          output: 'blocked/child',
        ),
        throwsA(isA<FileSystemException>()),
      );
      expect(parent.readAsStringSync(), 'keep');
      final package = await generateScaffold(
        project: project,
        name: 'product_catalog',
        output: 'local/packages',
      );
      expect(
        File('${package.path}/lib/src/product_catalog.dart').existsSync(),
        isTrue,
      );
    },
  );

  test('linked parents and package targets never receive writes', () async {
    final outside = await Directory.systemTemp.createTemp(
      'ds-scaffold-outside-',
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
        generateScaffold(
          project: project,
          name: 'Product',
          output: 'linked/child',
        ),
        throwsA(isA<FileSystemException>()),
      );
      await Directory('${project.path}/packages').create();
      await linkDirectory('${project.path}/packages/ds_product_scaffold');
      await expectLater(
        generateScaffold(project: project, name: 'Product'),
        throwsA(isA<FileSystemException>()),
      );
      expect(await outside.list().toList(), isEmpty);
    } finally {
      await outside.delete(recursive: true);
    }
  });
}
