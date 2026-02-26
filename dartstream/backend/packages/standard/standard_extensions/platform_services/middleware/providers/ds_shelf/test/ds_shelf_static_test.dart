import 'dart:io';

import 'package:ds_shelf/core/ds_shelf_core.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:shelf/shelf.dart';

void main() {
  group('DSShelfCore Static Files', () {
    late Directory tempDir;
    late DSShelfCore core;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('ds_shelf_static_test');
      await File('${tempDir.path}${Platform.pathSeparator}index.html')
          .writeAsString('Hello Static World');

      core = DSShelfCore();
      core.addStaticRoute(tempDir.path);
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    test('serves static file', () async {
      final response = await core.handler(
        Request('GET', Uri.parse('http://localhost/index.html')),
      );
      expect(response.statusCode, 200);
      expect(await response.readAsString(), 'Hello Static World');
    });

    test('serves root index.html', () async {
      final response = await core.handler(
        Request('GET', Uri.parse('http://localhost/')),
      );
      expect(response.statusCode, 200);
      expect(await response.readAsString(), 'Hello Static World');
    });
  });
}
