import 'dart:convert';
import 'dart:io';

import 'package:ds_cognito_auth_provider/ds_cognito_auth_provider.dart';

void main() async {
  // 1. Initialize Provider
  // current implementation has hardcoded mocks internally, so no need to inject HttpClient
  final provider = DSCognitoAuthProvider(
    userPoolId: 'mock_pool_server',
    clientId: 'mock_client_server',
    region: 'us-east-1',
  );

  await provider.initialize({});

  print('Cognito Auth Server running on http://localhost:8081');

  // Use loopbackIPv4 to avoid binding issues on some windows setups
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8081);

  await for (HttpRequest request in server) {
    try {
      // CORS Headers
      request.response.headers.add('Access-Control-Allow-Origin', '*');
      request.response.headers.add(
        'Access-Control-Allow-Methods',
        'POST, GET, OPTIONS',
      );
      request.response.headers.add(
        'Access-Control-Allow-Headers',
        'Content-Type, Authorization',
      );

      if (request.method == 'OPTIONS') {
        request.response.close();
        continue;
      }

      print('Request: ${request.method} ${request.uri.path}');

      final path = request.uri.path;

      if (path == '/login' && request.method == 'POST') {
        final content = await utf8.decoder.bind(request).join();
        final body = jsonDecode(content);
        final username = body['username'];
        final password = body['password'];

        await provider.signIn(username, password);
        final user = await provider.getCurrentUser();

        request.response.write(
          jsonEncode({
            'success': true,
            'user': {
              'id': user.id,
              'email': user.email,
              'displayName': user.displayName,
            },
            'message': 'Login successful (Mocked Internal)',
          }),
        );
      } else if (path == '/register' && request.method == 'POST') {
        final content = await utf8.decoder.bind(request).join();
        final body = jsonDecode(content);
        final email = body['email'];
        final password = body['password'];

        await provider.createAccount(email, password);

        request.response.write(
          jsonEncode({
            'success': true,
            'message': 'Registration successful (Mocked Internal)',
          }),
        );
      } else if (path == '/logout' && request.method == 'POST') {
        await provider.signOut();
        request.response.write(
          jsonEncode({'success': true, 'message': 'Logged out successfully'}),
        );
      } else {
        request.response.statusCode = HttpStatus.notFound;
        request.response.write('Not Found');
      }
    } catch (e) {
      print('Error: $e');
      request.response.statusCode = HttpStatus.internalServerError;
      request.response.write(
        jsonEncode({'success': false, 'error': e.toString()}),
      );
    } finally {
      await request.response.close();
    }
  }
}
