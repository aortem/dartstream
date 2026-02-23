import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:ds_error_handling/ds_error_handling.dart';

void main() async {
  // 1. Setup Router
  final router = Router();

  // Standard success route (returns JSON to be compatible with frontend logic)
  router.get('/hello', (Request request) {
    return Response.ok('{"message": "Hello, World!"}', headers: {'content-type': 'application/json'});
  });

  // Test Route: 404 Not Found
  router.get('/error/notfound', (Request request) {
    throw NotFoundError('The requested resource was not found.');
  });

  // Test Route: 400 Validation Error
  router.get('/error/validation', (Request request) {
    throw ValidationError('Invalid input parameters provided.');
  });

  // Test Route: 401 Unauthorized
  router.get('/error/unauthorized', (Request request) {
    throw UnauthorizedError('You are not authorized to access this resource.');
  });

  // Test Route: 500 Generic Exception (Simulated Crash)
  router.get('/error/crash', (Request request) {
    throw Exception('Database connection failed unexpectedly!');
  });
  
  // Static Files Handler
  // Use Platform.script to find the 'web' directory relative to this file
  // This ensures it works regardless of where the command is run from.
  final webDir = Directory(Platform.script.resolve('web').toFilePath());
  if (!webDir.existsSync()) {
    print('⚠️ Warning: Web directory not found at ${webDir.path}');
  }
  
  final staticHandler = createStaticHandler(webDir.path, defaultDocument: 'index.html');

  // 2. Setup Middleware Pipeline
  // We use dsErrorMiddleware to catch all errors thrown above.
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(dsErrorMiddleware()) // <--- The core feature
      .addHandler((request) {
        // Cascade: Try router first, then static files
        return Cascade().add(router.call).add(staticHandler).handler(request);
      });

  // 3. Start Server
  final port = 8080;
  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);
  
  print('🚀 Server running on http://localhost:${server.port}');
  print('🌐 Open your browser to see the demo!');
  print('   (Backend endpoints are also available via curl/client)');
}
