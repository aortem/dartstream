import 'dart:io';

import 'package:ds_shelf/core/ds_shelf_core.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:shelf/shelf.dart';

void main() {
  group('DSShelfCore file-based routing', () {
    late Directory tempDir;
    late DSShelfCore core;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('ds_shelf_file_routes');
      core = DSShelfCore();
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('maps index and dynamic route conventions', () async {
      await _createFile(tempDir, 'index.get.dart');
      await _createFile(tempDir, 'users/[id].get.dart');

      core.addFileBasedRoutes(
        tempDir.path,
        handlerFactory: (file, routePath, method) {
          return (request) => Response.ok('$method $routePath');
        },
      );

      final rootResponse = await core.handler(
        Request('GET', Uri.parse('http://localhost/')),
      );
      expect(rootResponse.statusCode, 200);
      expect(await rootResponse.readAsString(), 'GET /');

      final userResponse = await core.handler(
        Request('GET', Uri.parse('http://localhost/users/123')),
      );
      expect(userResponse.statusCode, 200);
      expect(await userResponse.readAsString(), 'GET /users/<id>');
    });

    test('respects file method suffix and baseRoute', () async {
      await _createFile(tempDir, 'login.post.dart');
      await _createFile(tempDir, 'profile.get.dart');

      core.addFileBasedRoutes(
        tempDir.path,
        baseRoute: '/api',
        handlerFactory: (file, routePath, method) {
          return (request) => Response.ok('$method $routePath');
        },
      );

      final postResponse = await core.handler(
        Request('POST', Uri.parse('http://localhost/api/login')),
      );
      expect(postResponse.statusCode, 200);
      expect(await postResponse.readAsString(), 'POST /api/login');

      final wrongMethod = await core.handler(
        Request('GET', Uri.parse('http://localhost/api/login')),
      );
      expect(wrongMethod.statusCode, 404);
    });

    test('supports nested index routes with and without trailing slash', () async {
      await _createFile(tempDir, 'subsection/index.get.dart');

      core.addFileBasedRoutes(
        tempDir.path,
        handlerFactory: (file, routePath, method) {
          return (request) => Response.ok('$method $routePath');
        },
      );

      final noSlash = await core.handler(
        Request('GET', Uri.parse('http://localhost/subsection')),
      );
      expect(noSlash.statusCode, 200);
      expect(await noSlash.readAsString(), 'GET /subsection');

      final withSlash = await core.handler(
        Request('GET', Uri.parse('http://localhost/subsection/')),
      );
      expect(withSlash.statusCode, 200);
      expect(await withSlash.readAsString(), 'GET /subsection');
    });
  });
}

Future<void> _createFile(Directory root, String relativePath) async {
  final separator = Platform.pathSeparator;
  final path = '${root.path}$separator${relativePath.replaceAll('/', separator)}';
  final file = File(path);
  await file.parent.create(recursive: true);
  await file.writeAsString('// test route file');
}
