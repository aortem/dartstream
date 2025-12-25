import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

/// Simple HTTP server to test Ping Identity OIDC integration
/// Run this server and open http://localhost:3000 in your browser
void main() async {
  // Create handler for static files from the test directory
  final staticHandler = createStaticHandler(
    'test',
    defaultDocument: 'index.html',
  );

  // Add CORS headers for local development
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsHeaders())
      .addHandler(staticHandler);

  // Start the server on port 3000
  final server = await shelf_io.serve(handler, 'localhost', 3000);

  print('🚀 Test server running!');
  print('');
  print('📍 Open in your browser: http://localhost:${server.port}');
  print('');
  print('🔐 PingOne Configuration:');
  print('   Environment ID: 89bcd671-bbf2-472e-99cb-2ffd24e4b5d6');
  print('   Client ID: e70846a0-ef26-472d-ad6b-d004f1d748df');
  print('   Issuer URL: https://auth.pingone.sg/89bcd671-bbf2-472e-99cb-2ffd24e4b5d6/as');
  print('');
  print('👤 Test User Credentials:');
  print('   Email: test@dartstream.com');
  print('   Password: TestPassword123!');
  print('');
  print('Press Ctrl+C to stop the server');
}

/// Middleware to add CORS headers for local development
Middleware _corsHeaders() {
  return createMiddleware(
    responseHandler: (Response response) {
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      });
    },
  );
}

