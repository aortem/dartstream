import 'dart:io';

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../lib/extensions/ds_shelf_extension.dart';

void main() {
  test('serveStaticFiles serves files under a custom route prefix', () async {
    final tempDir = await Directory.systemTemp.createTemp('ds_shelf_static_');

    try {
      final cssFile = File('${tempDir.path}${Platform.pathSeparator}app.css');
      await cssFile.writeAsString('body { color: red; }');

      final router = Router()..serveStaticFiles(tempDir.path, routePrefix: '/assets');

      final response = await router.call(
        Request('GET', Uri.parse('http://localhost/assets/app.css')),
      );

      expect(response.statusCode, 200);
      expect(await response.readAsString(), 'body { color: red; }');
    } finally {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    }
  });

  test('serveStaticFiles serves default index for the prefix root', () async {
    final tempDir = await Directory.systemTemp.createTemp('ds_shelf_static_');

    try {
      final indexFile = File('${tempDir.path}${Platform.pathSeparator}index.html');
      await indexFile.writeAsString('<h1>home</h1>');

      final router = Router()..serveStaticFiles(tempDir.path, routePrefix: '/public');

      final response = await router.call(
        Request('GET', Uri.parse('http://localhost/public/')),
      );

      expect(response.statusCode, 200);
      expect(await response.readAsString(), '<h1>home</h1>');
    } finally {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    }
  });

  test('serveStaticFiles redirects prefix without trailing slash', () async {
    final tempDir = await Directory.systemTemp.createTemp('ds_shelf_static_');

    try {
      final router = Router()..serveStaticFiles(tempDir.path, routePrefix: '/assets');

      final response = await router.call(
        Request('GET', Uri.parse('http://localhost/assets')),
      );

      expect(response.statusCode, 301);
      expect(response.headers['location'], '/assets/');
    } finally {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    }
  });

  test('serveStaticFiles returns 404 for missing files', () async {
    final tempDir = await Directory.systemTemp.createTemp('ds_shelf_static_');

    try {
      final router = Router()..serveStaticFiles(tempDir.path, routePrefix: '/assets');

      final response = await router.call(
        Request('GET', Uri.parse('http://localhost/assets/missing.txt')),
      );

      expect(response.statusCode, 404);
    } finally {
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    }
  });
}
