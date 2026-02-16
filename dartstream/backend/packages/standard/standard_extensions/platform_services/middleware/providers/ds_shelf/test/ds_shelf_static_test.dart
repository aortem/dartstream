import 'dart:io';
import 'package:ds_shelf/ds_shelf.dart';
import 'package:ds_shelf/core/ds_shelf_core.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

void main() {
  group('DSShelfCore Static Files', () {
    late HttpServer server;
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('ds_shelf_static_test');
      final file = File('${tempDir.path}/index.html');
      await file.writeAsString('Hello Static World');

      final core = DSShelfCore();
      core.addStaticRoute(tempDir.path);

      final handler = core.handler;
      server = await HttpServer.bind('localhost', 0);
      server.mount(handler);
    });

    tearDown(() async {
      await server.close();
      await tempDir.delete(recursive: true);
    });

    test('serves static file', () async {
      final response = await http.get(Uri.parse('http://localhost:${server.port}/index.html'));
      expect(response.statusCode, 200);
      expect(response.body, 'Hello Static World');
    });
    
    test('serves root index.html', () async {
      final response = await http.get(Uri.parse('http://localhost:${server.port}/'));
      expect(response.statusCode, 200);
      expect(response.body, 'Hello Static World');
    });
  });
}

extension on HttpServer {
  void mount(Handler handler) {
    listen((HttpRequest request) {
      handleRequest(request, handler);
    });
  }

  Future<void> handleRequest(HttpRequest request, Handler handler) async {
    final shelfRequest = shelf.Request(
      request.method,
      Uri.parse('http://${request.headers.host}:${server.port}${request.uri.path}'),
      body: request,
      headers: {}, // simplified
    );
    // Note: this is a simplified adapter for testing
    // real shelf_io.serve handles this better
    // But since we are testing core logic, maybe we can just invoke handler directly?
    // Using shelf_io.serve is better but requires shelf/shelf_io.dart
  }
}
// Actually, let's use shelf_io to serve properly
