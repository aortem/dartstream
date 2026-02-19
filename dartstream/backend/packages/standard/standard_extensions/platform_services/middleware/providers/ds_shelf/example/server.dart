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
  // Merging feature: returning timestamp (from development) + simple message
  server.addGetRoute('/api/hello', (Request request) {
     return Response.ok(
      '{"message": "Hello from DartStream API!", "timestamp": "${DateTime.now().toIso8601String()}"}',
      headers: {'Content-Type': 'application/json'},
    );
  });

  // Echo route (from HEAD)
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
  // Attempting to resolve path correctly to avoid crash
  // If running from root, 'example/public' is correct. If running from example/, 'public' is correct.
  String? staticPath;
  if (Directory('example/public').existsSync()) {
    staticPath = 'example/public';
  } else if (Directory('public').existsSync()) {
    staticPath = 'public';
  }

  if (staticPath != null) {
    server.addStaticRoute(staticPath);
    print('📁 Static files will be served from: $staticPath');
  } else {
    print('Warning: public directory not found for static files. Static serving disabled.');
  }

  // 3. Print Routes (Feature from HEAD)
  print('\n🖨️  Registered Routes:');
  server.printRoutes();

  // 4. Start Server
  final handler = server.handler;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  await shelf_io.serve(handler, InternetAddress.loopbackIPv4, port);

  print('\n✅ Server running at http://localhost:$port');
  print('  • http://localhost:$port/api/hello  (API endpoint)');
  print('  • http://localhost:$port/echo       (Echo endpoint)');
  if (staticPath != null) {
     print('  • http://localhost:$port/           (index.html)');
  }
}
