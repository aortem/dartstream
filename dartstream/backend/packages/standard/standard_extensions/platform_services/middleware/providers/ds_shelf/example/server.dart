import 'dart:io';
import 'package:ds_shelf/ds_shelf.dart';
import 'package:ds_shelf/core/ds_shelf_core.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf/shelf.dart';

void main() async {
  print('🚀 Starting DartStream Static Files Demo Server...');

  final server = DSShelfCore();

  // 1. Register API Routes
  server.addGetRoute('/api/hello', (Request request) {
    return Response.ok('{"message": "Hello from DartStream Backend!"}',
        headers: {'content-type': 'application/json'});
  });

  // 2. Register Static Files
  // Ensure you have a 'public' folder in your execution directory
  server.addStaticRoute('public'); 

  // 3. Print Routes (New Feature Verification)
  print('\n🖨️  Registered Routes:');
  server.printRoutes();

  // 4. Start Server
  final handler = server.handler;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final httpServer = await shelf_io.serve(handler, 'localhost', port);

  print('\n✅ Server running at http://localhost:$port');
  print('  • http://localhost:$port/api/hello  (API endpoint)');
}
