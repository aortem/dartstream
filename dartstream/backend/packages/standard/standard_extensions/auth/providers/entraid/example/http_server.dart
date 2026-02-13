import 'dart:convert';
import 'dart:io';
import 'package:ds_entraid_auth_provider/ds_entraid_auth_provider.dart';

final authProvider = DSEntraIDAuthProvider(
  tenantId: 'mock-tenant',
  clientId: 'mock-client',
  clientSecret: 'mock-secret',
);

Future<void> main() async {
  await authProvider.initialize({});

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('Mock EntraID server running on http://localhost:8080');

  await for (HttpRequest request in server) {
    // --- Handle CORS preflight ---
    request.response.headers
      ..add('Access-Control-Allow-Origin', '*')
      ..add('Access-Control-Allow-Methods', 'POST, GET, OPTIONS')
      ..add('Access-Control-Allow-Headers', 'Content-Type');

    if (request.method == 'OPTIONS') {
      request.response
        ..statusCode = 200
        ..close();
      continue;
    }

    final path = request.uri.path;
    final method = request.method;

    try {
      if (path == '/signup' && method == 'POST') {
        final body = await utf8.decoder.bind(request).join();
        final data = json.decode(body);
        final email = data['email'];
        final password = data['password'];

        await authProvider.createAccount(email, password);
        request.response
          ..statusCode = 200
          ..write(json.encode({'message': 'Signup successful'}));
      } else if (path == '/signin' && method == 'POST') {
        final body = await utf8.decoder.bind(request).join();
        final data = json.decode(body);
        final email = data['email'];
        final password = data['password'];

        await authProvider.signIn(email, password);
        final currentUser = await authProvider.getCurrentUser();
        request.response
          ..statusCode = 200
          ..write(json.encode({
            'message': 'Signin successful',
            'user': {
              'id': currentUser.id,
              'email': currentUser.email,
              'displayName': currentUser.displayName
            }
          }));
      } else if (path == '/signout' && method == 'POST') {
        await authProvider.signOut();
        request.response
          ..statusCode = 200
          ..write(json.encode({'message': 'Signout successful'}));
      } else {
        request.response
          ..statusCode = 404
          ..write(json.encode({'error': 'Endpoint not found'}));
      }
    } catch (e) {
      request.response
        ..statusCode = 400
        ..write(json.encode({'error': e.toString()}));
    } finally {
      await request.response.close();
    }
  }
}
