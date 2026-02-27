import 'dart:convert';
import 'dart:io';

import '../lib/ds_okta_auth_provider.dart';

final provider = DSOktaAuthProvider();

Future<void> main() async {
  // Initialize Okta provider in DEV mode
  await provider.initialize({
    '__dev__': true,
  });

  final server = await HttpServer.bind(
    InternetAddress.loopbackIPv4,
    8080,
  );

  print('✅ Okta test server running on http://localhost:8080');

  await for (HttpRequest request in server) {
    try {
      // Enable CORS
      request.response.headers
        ..add('Access-Control-Allow-Origin', '*')
        ..add('Access-Control-Allow-Headers', 'Content-Type')
        ..add('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');

      if (request.method == 'OPTIONS') {
        request.response.statusCode = HttpStatus.noContent;
        await request.response.close();
        continue;
      }

      switch (request.uri.path) {
        case '/signup':
          await _signup(request);
          break;

        case '/login':
          await _login(request);
          break;

        case '/logout':
          await _logout(request);
          break;

        case '/me':
          await _me(request);
          break;

        default:
          _notFound(request);
      }
    } catch (e) {
      _error(request, e.toString());
    }
  }
}

Future<void> _signup(HttpRequest request) async {
  final body = await utf8.decoder.bind(request).join();
  final data = jsonDecode(body);

  await provider.createAccount(
    data['email'],
    data['password'],
  );

  _json(request, {'success': true});
}

Future<void> _login(HttpRequest request) async {
  final body = await utf8.decoder.bind(request).join();
  final data = jsonDecode(body);

  await provider.signIn(
    data['email'],
    data['password'],
  );

  final user = await provider.getCurrentUser();

  _json(request, {
    'id': user.id,
    'email': user.email,
    'displayName': user.displayName,
  });
}

Future<void> _logout(HttpRequest request) async {
  await provider.signOut();
  _json(request, {'success': true});
}

Future<void> _me(HttpRequest request) async {
  final user = await provider.getCurrentUser();

  _json(request, {
    'id': user.id,
    'email': user.email,
    'displayName': user.displayName,
  });
}

void _json(HttpRequest request, Map<String, dynamic> data) {
  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.json
    ..write(jsonEncode(data))
    ..close();
}

void _notFound(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.notFound
    ..write('Not Found')
    ..close();
}

void _error(HttpRequest request, String message) {
  request.response
    ..statusCode = HttpStatus.internalServerError
    ..headers.contentType = ContentType.json
    ..write(jsonEncode({'error': message}))
    ..close();
}
