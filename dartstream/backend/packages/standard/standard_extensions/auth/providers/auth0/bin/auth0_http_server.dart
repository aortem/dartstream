import 'dart:convert';
import 'dart:io';

import '../lib/ds_auth0_auth_provider.dart';

late final DSAuth0AuthProvider authProvider;

Future<void> main() async {
  authProvider = DSAuth0AuthProvider(
    domain: 'Domain',
    clientId: 'ClientID',
    clientSecret: 'ClientSecret',
    audience: 'Audience',
  );

  await authProvider.initialize({});

  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);

  print('✅ Auth server running on http://localhost:8080');

  await for (HttpRequest request in server) {
    _handleRequest(request);
  }
}

Future<void> _handleRequest(HttpRequest req) async {
  // --- CORS ---
  req.response.headers
    ..set('Access-Control-Allow-Origin', '*')
    ..set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
    ..set('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method == 'OPTIONS') {
    req.response
      ..statusCode = HttpStatus.ok
      ..close();
    return;
  }

  try {
    if (req.uri.path == '/auth/login' && req.method == 'POST') {
      // Read and decode the request body
      final body = await utf8.decoder.bind(req).join();
      Map<String, dynamic> data;
      try {
        data = jsonDecode(body) as Map<String, dynamic>;
      } catch (_) {
        req.response
          ..statusCode = HttpStatus.badRequest
          ..write(jsonEncode({'error': 'Invalid JSON body'}))
          ..close();
        return;
      }

      // Extract email and password safely
      final email = data['email']?.toString();
      final password = data['password']?.toString();

      // Validate inputs
      if (email == null ||
          password == null ||
          email.isEmpty ||
          password.isEmpty) {
        req.response
          ..statusCode = HttpStatus.badRequest
          ..write(jsonEncode({'error': 'Missing email or password'}))
          ..close();
        return;
      }

      try {
        // Attempt login via Auth0 provider
        await authProvider.signIn(email, password);

        // Fetch current user
        final user = await authProvider.getCurrentUser();

        // Respond with user info
        _json(req, {
          'id': user.id,
          'email': user.email,
          'name': user.displayName,
        });
      } catch (e) {
        // Catch any Auth0 errors and respond
        req.response
          ..statusCode = HttpStatus.unauthorized
          ..write(jsonEncode({'error': e.toString()}))
          ..close();
      }

      return;
    }

    if (req.uri.path == '/auth/register' && req.method == 'POST') {
      final body = await utf8.decoder.bind(req).join();
      final data = jsonDecode(body);

      await authProvider.createAccount(
        data['email'],
        data['password'],
        displayName: data['name'],
      );

      _json(req, {'success': true});
      return;
    }

    if (req.uri.path == '/auth/login' && req.method == 'POST') {
      final body = await utf8.decoder.bind(req).join();
      final data = jsonDecode(body);

      // Convert to Strings safely
      final email = (data['email'] ?? '').toString().trim();
      final password = (data['password'] ?? '').toString();

      if (email.isEmpty || password.isEmpty) {
        req.response
          ..statusCode = HttpStatus.badRequest
          ..write(jsonEncode({'error': 'Missing email or password'}))
          ..close();
        return;
      }

      try {
        await authProvider.signIn(email, password); // email as username
        final user = await authProvider.getCurrentUser();

        _json(req, {
          'id': user.id,
          'email': user.email,
          'name': user.displayName,
        });
      } catch (e) {
        req.response
          ..statusCode = HttpStatus.unauthorized
          ..write(jsonEncode({'error': e.toString()}))
          ..close();
      }

      return;
    }

    if (req.uri.path == '/auth/me' && req.method == 'GET') {
      final user = await authProvider.getCurrentUser();
      _json(req, {
        'id': user.id,
        'email': user.email,
        'name': user.displayName,
      });
      return;
    }

    // ---- Not Found ----
    req.response
      ..statusCode = HttpStatus.notFound
      ..write('Not Found')
      ..close();
  } catch (e) {
    req.response
      ..statusCode = HttpStatus.unauthorized
      ..write(jsonEncode({'error': e.toString()}))
      ..close();
  }
}

void _json(HttpRequest req, Map<String, dynamic> data) {
  req.response.headers.contentType = ContentType.json;
  req.response
    ..statusCode = HttpStatus.ok
    ..write(jsonEncode(data))
    ..close();
}
