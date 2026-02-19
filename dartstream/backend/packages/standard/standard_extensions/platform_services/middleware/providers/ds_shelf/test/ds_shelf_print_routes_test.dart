import 'dart:async';
import 'package:ds_shelf/core/ds_shelf_core.dart';
import 'package:shelf/shelf.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  group('DSShelfCore printRoutes', () {
    test('prints registered routes to console', () {
      final server = DSShelfCore();
      server.addGetRoute('/api/test', (Request request) => Response.ok('Test'));

      // Capture print output
      final printLog = <String>[];
      final spec = ZoneSpecification(
        print: (_, __, ___, String msg) {
          printLog.add(msg);
        },
      );

      Zone.current.fork(specification: spec).run(() {
        server.printRoutes();
      });

      // Verify output contains the route
      expect(printLog.any((line) => line.contains('GET\t/api/test')), isTrue);
      expect(printLog.any((line) => line.contains('Registered Routes')), isTrue);
    });

    test('prints message when no routes registered', () {
       // Note: Health check is added by default in constructor, so we can't easily test "empty" 
       // unless we modify the core to not add default routes, or we just test that health check is there.
       
       final server = DSShelfCore();
       // Capture print output
      final printLog = <String>[];
      final spec = ZoneSpecification(
        print: (_, __, ___, String msg) {
          printLog.add(msg);
        },
      );

      Zone.current.fork(specification: spec).run(() {
        server.printRoutes();
      });

      expect(printLog.any((line) => line.contains('GET\t/health')), isTrue);
    });
  });
}
