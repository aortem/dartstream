import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:ds_cognito_auth_provider/ds_cognito_auth_provider.dart';
import 'mock_client.dart';

void main(List<String> args) async {
  // 1. Initialize Provider (Mock Mode)
  final provider = DSCognitoAuthProvider(
    userPoolId: 'mock_pool_id',
    clientId: 'mock_client_id',
    region: 'us-mock-1',
  );
  
  await provider.initialize({
      'httpClient': MockCognitoHttpClient()
  });

  print('✅ DSCognitoAuthProvider Middleware Initialized (Mock Mode)');

  // 2. Handler
  Response _cors(Response response) => response.change(headers: {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Access-Control-Allow-Headers': 'Origin, Content-Type',
  });

  Future<Response> _handler(Request request) async {
    if (request.method == 'OPTIONS') {
      return Response.ok('');
    }

    final path = request.url.path;

    try {
        // Serve Frontend
        if (path == '' || path == 'index.html') {
            final indexFile = File('example/client/index.html');
            if (indexFile.existsSync()) {
                 return Response.ok(indexFile.readAsStringSync(), headers: {'content-type': 'text/html'});
            }
            return Response.notFound('Client not found. Run from package root.');
        }

        // Auth Endpoints
        if (path == 'auth/register' && request.method == 'POST') {
            final payload = jsonDecode(await request.readAsString());
            await provider.createAccount(payload['email'], payload['password']);
            return Response.ok(jsonEncode({'message': 'User registered'}));
        }

        if (path == 'auth/login' && request.method == 'POST') {
             final payload = jsonDecode(await request.readAsString());
             await provider.signIn(payload['email'], payload['password']);
             final isValid = await provider.verifyToken();
             return Response.ok(jsonEncode({
                'message': 'Login successful',
                'token': isValid ? 'mock_valid_token_123' : 'invalid'
             }));
        }

        if (path == 'auth/user' && request.method == 'GET') {
             final user = await provider.getCurrentUser();
             return Response.ok(jsonEncode({
                'id': user.id,
                'email': user.email
             }));
        }

        if (path == 'auth/logout' && request.method == 'POST') {
             await provider.signOut();
             return Response.ok(jsonEncode({'message': 'Logged out'}));
        }

        return Response.notFound('Not Found');

    } catch (e) {
        if (e.toString().contains('No user signed in')) {
           return Response.notFound(jsonEncode({'message': 'No user signed in'}));
        }
        return Response.internalServerError(body: jsonEncode({'message': e.toString()}));
    }
  }

  // 3. Start Server
  final handler = Pipeline()
      .addMiddleware((inner) => (req) async => _cors(await inner(req)))
      .addMiddleware(logRequests())
      .addHandler(_handler);

  final server = await io.serve(handler, 'localhost', 8081);
  print('🚀 Server running on http://${server.address.host}:${server.port}');
  print('👉 Open your browser to http://localhost:8081 to test');
}
