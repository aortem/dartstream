import 'dart:io';
import 'package:ds_shelf/ds_shelf.dart';
import 'package:ds_shelf/core/ds_shelf_core.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf/shelf.dart';

void main() async {
  print('🚀 Starting DartStream Static Files Demo Server...');
  
  // Create the server core
  final server = DSShelfCore();
  
  // Add a simple API route for testing
  server.addGetRoute('/api/hello', (Request request) {
    return Response.ok(
      '{"message": "Hello from DartStream API!", "timestamp": "${DateTime.now().toIso8601String()}"}',
      headers: {'Content-Type': 'application/json'},
    );
  });
  
  // Serve static files from the 'public' directory
  // This demonstrates the new static file serving capability
  server.addStaticRoute('public');
  
  print('📁 Static files will be served from: public/');
  print('🔗 API endpoint available at: /api/hello');
  
  // Start the server
  final port = int.tryParse(Platform.environment['PORT'] ?? '8080') ?? 8080;
  final handler = server.handler;
  
  final httpServer = await shelf_io.serve(handler, 'localhost', port);
  
  print('✅ Server running at http://localhost:$port');
  print('');
  print('Try these URLs:');
  print('  • http://localhost:$port/           (index.html)');
  print('  • http://localhost:$port/about.html (about page)');
  print('  • http://localhost:$port/styles.css (stylesheet)');
  print('  • http://localhost:$port/script.js  (javascript)');
  print('  • http://localhost:$port/logo.svg   (image)');
  print('  • http://localhost:$port/api/hello  (API endpoint)');
  print('');
  print('Press Ctrl+C to stop the server.');
}
