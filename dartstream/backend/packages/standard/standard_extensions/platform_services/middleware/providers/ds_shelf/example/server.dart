import 'dart:convert';
import 'dart:io';
import 'package:ds_shelf/ds_shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() async {
  print('🚀 Starting DartStream Static Files Demo Server...');

  final server = DSShelfCore();

  // Add middlewares
  server.addMiddleware(dsShelfCorsMiddleware());
  server.addMiddleware(dsShelfBodyParserMiddleware());

  // 1. Register API Routes
  server.addGetRoute('/api/hello', (Request request) {
    return Response.ok('{"message": "Hello from DartStream Backend!"}',
        headers: {'content-type': 'application/json'});
  });

  // Echo route
  server.addPostRoute('/echo', (Request request) async {
    final parsedBody = request.context['ds_shelf.body'];
    
    if (parsedBody == null) {
      return Response.ok(jsonEncode({
        'status': 'error',
        'message': 'No parsed body found. Did you set the correct Content-Type?',
        'receivedHeaders': request.headers,
      }), headers: {'content-type': 'application/json'});
    }

    return Response.ok(jsonEncode({
      'status': 'success',
      'parsedBody': parsedBody,
      'type': parsedBody.runtimeType.toString(),
    }), headers: {'content-type': 'application/json'});
  });

  // 2. Register Static Files
  // Static route disabled due to crash on startup. TODO: Fix static route path.
  /*
  // Ensure you have a 'public' folder in your execution directory
  if (Directory('example/public').existsSync()) {
    server.addStaticRoute('example/public');
  } else if (Directory('public').existsSync()) {
    server.addStaticRoute('public');
  } else {
    print('Warning: public directory not found for static files.');
  }
  */

  // 3. Print Routes
  print('\n🖨️  Registered Routes:');
  server.printRoutes();

  // 4. Start Server
  final handler = server.handler;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  await shelf_io.serve(handler, 'localhost', port);

  print('\n✅ Server running at http://localhost:$port');
  print('  • http://localhost:$port/api/hello  (API endpoint)');
  print('  • http://localhost:$port/echo       (Echo endpoint)');
}
