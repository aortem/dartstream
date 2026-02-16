import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:ds_entraid_auth_provider/ds_entraid_auth_provider.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';

void main() async {
  // Initialize the EntraID auth provider
  final auth = DSEntraIDAuthProvider(
    tenantId: 'demo-tenant',
    clientId: 'demo-client-id',
    clientSecret: 'demo-client-secret',
  );
  
  await auth.initialize({});
  
  print('EntraID Auth Provider initialized');
  
  // Create the handler pipeline
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(_router(auth));
  
  // Start the server
  final server = await shelf_io.serve(handler, 'localhost', 8080);
  print('Backend server running on http://${server.address.host}:${server.port}');
  print('Press Ctrl+C to stop the server');
}

Handler _router(DSEntraIDAuthProvider auth) {
  return (Request request) async {
    final path = request.url.path;
    final method = request.method;
    
    try {
      // Handle preflight requests
      if (method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeaders());
      }
      
      // Route handlers
      if (path == 'api/auth/register' && method == 'POST') {
        return await _handleRegister(request, auth);
      } else if (path == 'api/auth/login' && method == 'POST') {
        return await _handleLogin(request, auth);
      } else if (path == 'api/auth/logout' && method == 'POST') {
        return await _handleLogout(request, auth);
      } else if (path == 'api/auth/user' && method == 'GET') {
        return await _handleGetUser(request, auth);
      } else if (path == 'api/auth/verify' && method == 'GET') {
        return await _handleVerify(request, auth);
      } else if (path == 'health' && method == 'GET') {
        return _jsonResponse({'status': 'ok', 'message': 'Server is running'});
      }
      
      return Response.notFound(
        json.encode({'error': 'Not found'}),
        headers: _jsonHeaders(),
      );
    } catch (e) {
      print('Error handling request: $e');
      return Response.internalServerError(
        body: json.encode({'error': 'Internal server error', 'details': e.toString()}),
        headers: _jsonHeaders(),
      );
    }
  };
}

Future<Response> _handleRegister(Request request, DSEntraIDAuthProvider auth) async {
  try {
    final body = await request.readAsString();
    final data = json.decode(body) as Map<String, dynamic>;
    
    final email = data['email'] as String?;
    final password = data['password'] as String?;
    final displayName = data['displayName'] as String?;
    
    if (email == null || password == null) {
      return _jsonResponse(
        {'error': 'Email and password are required'},
        statusCode: 400,
      );
    }
    
    await auth.createAccount(email, password, displayName: displayName);
    
    return _jsonResponse({
      'success': true,
      'message': 'Account created successfully',
    });
  } on DSAuthError catch (e) {
    return _jsonResponse(
      {'error': e.message},
      statusCode: e.code ?? 400,
    );
  } catch (e) {
    return _jsonResponse(
      {'error': 'Registration failed', 'details': e.toString()},
      statusCode: 500,
    );
  }
}

Future<Response> _handleLogin(Request request, DSEntraIDAuthProvider auth) async {
  try {
    final body = await request.readAsString();
    final data = json.decode(body) as Map<String, dynamic>;
    
    final email = data['email'] as String?;
    final password = data['password'] as String?;
    
    if (email == null || password == null) {
      return _jsonResponse(
        {'error': 'Email and password are required'},
        statusCode: 400,
      );
    }
    
    await auth.signIn(email, password);
    final user = await auth.getCurrentUser();
    
    // Generate a simple token for the session
    final token = 'session_${user.id}_${DateTime.now().millisecondsSinceEpoch}';
    
    return _jsonResponse({
      'success': true,
      'token': token,
      'user': {
        'id': user.id,
        'email': user.email,
        'displayName': user.displayName,
        'customAttributes': user.customAttributes,
      },
    });
  } on DSAuthError catch (e) {
    return _jsonResponse(
      {'error': e.message},
      statusCode: e.code ?? 401,
    );
  } catch (e) {
    return _jsonResponse(
      {'error': 'Login failed', 'details': e.toString()},
      statusCode: 500,
    );
  }
}

Future<Response> _handleLogout(Request request, DSEntraIDAuthProvider auth) async {
  try {
    await auth.signOut();
    
    return _jsonResponse({
      'success': true,
      'message': 'Logged out successfully',
    });
  } on DSAuthError catch (e) {
    return _jsonResponse(
      {'error': e.message},
      statusCode: e.code ?? 400,
    );
  } catch (e) {
    return _jsonResponse(
      {'error': 'Logout failed', 'details': e.toString()},
      statusCode: 500,
    );
  }
}

Future<Response> _handleGetUser(Request request, DSEntraIDAuthProvider auth) async {
  try {
    final user = await auth.getCurrentUser();
    
    return _jsonResponse({
      'user': {
        'id': user.id,
        'email': user.email,
        'displayName': user.displayName,
        'customAttributes': user.customAttributes,
      },
    });
  } on DSAuthError catch (e) {
    return _jsonResponse(
      {'error': e.message},
      statusCode: e.code ?? 401,
    );
  } catch (e) {
    return _jsonResponse(
      {'error': 'Failed to get user', 'details': e.toString()},
      statusCode: 500,
    );
  }
}

Future<Response> _handleVerify(Request request, DSEntraIDAuthProvider auth) async {
  try {
    final token = request.headers['authorization']?.replaceFirst('Bearer ', '');
    
    if (token == null) {
      return _jsonResponse(
        {'valid': false, 'error': 'No token provided'},
        statusCode: 401,
      );
    }
    
    final isValid = await auth.verifyToken(token);
    
    return _jsonResponse({
      'valid': isValid,
    });
  } catch (e) {
    return _jsonResponse(
      {'valid': false, 'error': e.toString()},
      statusCode: 500,
    );
  }
}

Response _jsonResponse(Map<String, dynamic> data, {int statusCode = 200}) {
  return Response(
    statusCode,
    body: json.encode(data),
    headers: _jsonHeaders(),
  );
}

Map<String, String> _jsonHeaders() {
  return {
    'Content-Type': 'application/json',
    ..._corsHeaders(),
  };
}

Map<String, String> _corsHeaders() {
  return {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
  };
}
