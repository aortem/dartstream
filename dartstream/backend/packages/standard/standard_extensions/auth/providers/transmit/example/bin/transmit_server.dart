// Transmit Authentication Sample Server
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:ds_transmit_auth_provider/ds_transmit_auth_export.dart';

/// Dev mode flag - set to false to use real Transmit
const bool kIsDev = true;

/// Session storage
final Map<String, Map<String, dynamic>> _sessions = {};

/// Auth provider instance
late DSTransmitAuthProvider _authProvider;

/// Generate secure session ID
String _generateSessionId() {
  final rand = Random.secure();
  return List.generate(32, (_) => rand.nextInt(256))
      .map((b) => b.toRadixString(16).padLeft(2, '0'))
      .join();
}

/// Get session ID from request
String? _getSessionId(Request request) {
  final authHeader = request.headers['authorization'];
  if (authHeader == null) return null;
  return authHeader.startsWith('Bearer ') 
      ? authHeader.substring(7) 
      : authHeader;
}

/// CORS middleware
Middleware corsHeaders() {
  return (Handler innerHandler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok(
          '',
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization',
            'Access-Control-Allow-Credentials': 'true',
          },
        );
      }

      final response = await innerHandler(request);
      return response.change(headers: {
        ...response.headers,
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization',
        'Access-Control-Allow-Credentials': 'true',
      });
    };
  };
}

/// Handle user login
Future<Response> handleLogin(Request request) async {
  try {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;

    final email = data['email'] as String?;
    final password = data['password'] as String?;

    if (email == null || password == null) {
      return Response(
        400,
        body: jsonEncode({'error': 'Email and password are required'}),
        headers: {'content-type': 'application/json'},
      );
    }

    print('[AUTH] Authenticating user: $email');
    
    // Use Transmit provider to authenticate
    await _authProvider.signIn(email, password);
    final user = await _authProvider.getCurrentUser();
    
    // Generate session
    final sessionId = _generateSessionId();
    
    _sessions[sessionId] = {
      'id': user.id,
      'email': user.email,
      'displayName': user.displayName,
    };

    return Response.ok(
      jsonEncode({
        'success': true,
        'sessionId': sessionId,
        'user': {
          'id': user.id,
          'email': user.email,
          'displayName': user.displayName,
        },
      }),
      headers: {'content-type': 'application/json'},
    );
  } catch (e) {
    print('[ERROR] Login error: $e');
    return Response(
      401,
      body: jsonEncode({'error': 'Invalid credentials: ${e.toString()}'}),
      headers: {'content-type': 'application/json'},
    );
  }
}

/// Handle session check
Future<Response> handleSession(Request request) async {
  final sessionId = _getSessionId(request);

  if (sessionId == null || !_sessions.containsKey(sessionId)) {
    return Response(
      401,
      body: jsonEncode({'error': 'Unauthenticated'}),
      headers: {'content-type': 'application/json'},
    );
  }

  return Response.ok(
    jsonEncode({'user': _sessions[sessionId]}),
    headers: {'content-type': 'application/json'},
  );
}

/// Handle logout
Future<Response> handleLogout(Request request) async {
  final sessionId = _getSessionId(request);
  
  try {
    // Logout from Transmit provider
    await _authProvider.signOut();
    
    if (sessionId != null) {
      _sessions.remove(sessionId);
    }

    return Response.ok(
      jsonEncode({'success': true}),
      headers: {'content-type': 'application/json'},
    );
  } catch (e) {
    print('[ERROR] Logout error: $e');
    return Response(
      500,
      body: jsonEncode({'error': e.toString()}),
      headers: {'content-type': 'application/json'},
    );
  }
}

/// Handle token refresh
Future<Response> handleRefresh(Request request) async {
  try {
    final body = await request.readAsString();
    final data = jsonDecode(body) as Map<String, dynamic>;

    final refreshToken = data['refreshToken'] as String?;

    if (refreshToken == null) {
      return Response(
        400,
        body: jsonEncode({'error': 'Refresh token is required'}),
        headers: {'content-type': 'application/json'},
      );
    }

    print('[AUTH] Refreshing token');
    
    final newAccessToken = await _authProvider.refreshToken(refreshToken);

    return Response.ok(
      jsonEncode({
        'success': true,
        'accessToken': newAccessToken,
      }),
      headers: {'content-type': 'application/json'},
    );
  } catch (e) {
    print('[ERROR] Token refresh error: $e');
    return Response(
      401,
      body: jsonEncode({'error': e.toString()}),
      headers: {'content-type': 'application/json'},
    );
  }
}

/// Health check endpoint
Response handleHealth(Request request) {
  return Response.ok(
    jsonEncode({'status': 'ok', 'service': 'transmit-auth-demo', 'mode': 'development'}),
    headers: {'content-type': 'application/json'},
  );
}

/// Main server
Future<void> main() async {
  print('Starting Transmit Authentication Demo Server');
  print('Mode: DEVELOPMENT (Mock Authentication)');
  
  // Initialize Transmit provider
  _authProvider = DSTransmitAuthProvider();
  await _authProvider.initialize({
    'apiKey': 'demo-api-key',
    'serviceId': 'demo-service-id',
  });
  
  print('SUCCESS: Transmit provider initialized');
  print('SUCCESS: Ready to accept requests');

  // Setup routes
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler((Request request) async {
    final path = request.url.path;
    final method = request.method;

    // API endpoints
    if (method == 'GET' && path == 'health') {
      return handleHealth(request);
    }

    if (method == 'POST' && path == 'auth/login') {
      return handleLogin(request);
    }

    if (method == 'GET' && path == 'auth/session') {
      return handleSession(request);
    }

    if (method == 'POST' && path == 'auth/logout') {
      return handleLogout(request);
    }

    if (method == 'POST' && path == 'auth/refresh') {
      return handleRefresh(request);
    }

    // Serve static files
    if (method == 'GET') {
      // Serve index.html for root path
      if (path.isEmpty || path == '/') {
        final indexFile = File('client/index.html');
        if (await indexFile.exists()) {
          final content = await indexFile.readAsString();
          return Response.ok(
            content,
            headers: {'content-type': 'text/html'},
          );
        }
      }
      
      // Serve other static files
      final filePath = 'client/$path';
      final file = File(filePath);
      
      if (await file.exists()) {
        final content = await file.readAsString();
        String contentType = 'text/plain';
        
        if (path.endsWith('.html')) {
          contentType = 'text/html';
        } else if (path.endsWith('.css')) {
          contentType = 'text/css';
        } else if (path.endsWith('.js')) {
          contentType = 'application/javascript';
        } else if (path.endsWith('.json')) {
          contentType = 'application/json';
        }
        
        return Response.ok(
          content,
          headers: {'content-type': contentType},
        );
      }
    }

    return Response.notFound(
      jsonEncode({'error': 'Not Found'}),
      headers: {'content-type': 'application/json'},
    );
  });

  final server = await io.serve(handler, '0.0.0.0', 4000);
  print('Server running at http://${server.address.host}:${server.port}');
  print('Available endpoints:');
  print('   GET  /health');
  print('   POST /auth/login');
  print('   GET  /auth/session');
  print('   POST /auth/logout');
  print('   POST /auth/refresh');
  print('\nTIP: Open http://localhost:4000 in your browser to test the app');
}
