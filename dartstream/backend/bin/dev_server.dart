// bin/dev_server.dart

import 'dart:convert';
import 'dart:math';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

import 'package:ds_auth_base/ds_auth_base_export.dart';

// Auth Providers
import 'package:ds_auth0_auth_provider/ds_auth0_auth_export.dart';
import 'package:ds_cognito_auth_provider/ds_cognito_auth_export.dart';
import 'package:ds_entraid_auth_provider/ds_entraid_auth_export.dart';
import 'package:ds_fingerprint_auth_provider/ds_fingerprint_auth_export.dart';
import 'package:ds_okta_auth_provider/ds_okta_auth_export.dart';
import 'package:ping_identity_dart_auth_sdk/ds_ping_auth_export.dart';
import 'package:ds_transmit_auth_provider/ds_transmit_auth_export.dart';

/// ===============================
/// DEV mode flag
/// ===============================
const bool kIsDev = true;

/// ===============================
/// DEV-ONLY PROVIDER & SESSION STORE
/// ===============================
final Map<String, DSAuthProvider> _providers = {};
final Map<String, Map<String, dynamic>> _sessions = {};

/// ===============================
/// UTILITY FUNCTIONS
/// ===============================
String _generateSessionId() {
  final rand = Random.secure();
  return List.generate(32, (_) => rand.nextInt(256))
      .map((b) => b.toRadixString(16).padLeft(2, '0'))
      .join();
}

String? _getSessionId(Request request) {
  final cookie = request.headers['cookie'];
  if (cookie == null) return null;

  for (final part in cookie.split(';')) {
    final kv = part.trim().split('=');
    if (kv.length == 2 && kv[0] == 'dartstream_session') {
      return kv[1];
    }
  }
  return null;
}

/// ===============================
/// CORS MIDDLEWARE
/// ===============================
Middleware corsHeaders() {
  return (Handler innerHandler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('',
            headers: {
              'Access-Control-Allow-Origin': 'http://localhost:3000',
              'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
              'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
              'Access-Control-Allow-Credentials': 'true',
            });
      }

      final response = await innerHandler(request);
      return response.change(headers: {
        ...response.headers,
        'Access-Control-Allow-Origin': 'http://localhost:3000',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
        'Access-Control-Allow-Credentials': 'true',
      });
    };
  };
}

/// ===============================
/// AUTH ROUTE HANDLERS
/// ===============================
Future<Response> handleSignIn(Request request) async {
  final body = await request.readAsString();

  Map<String, dynamic> data;
  try {
    data = jsonDecode(body) as Map<String, dynamic>;
  } catch (e) {
    return Response(
      400,
      body: jsonEncode({'error': 'Invalid JSON payload'}),
      headers: {'content-type': 'application/json'},
    );
  }

  final String providerKey = data['provider'] ?? 'okta';
  final bool isE2E = (data['__e2e__'] ?? false) == true;

  // DEBUG log for incoming payload
  print('🔥 SignIn payload received: $data');

  Map<String, dynamic> user;

  if (isE2E) {
    // ✅ DEV/E2E branch: always succeed
user = {
  'id': 'dev-user-${providerKey}',
  'uid': 'dev-user-${providerKey}', // ✅ ADD THIS
  'email': data['email'] ?? 'dev@dartstream.dev',
  'subscriptionStatus': 'active',
  'isSandbox': true,
  'provider': providerKey,
};

  } else {
    // Normal DEV mode: try provider if exists, otherwise fallback
    final provider = _providers[providerKey] ?? _providers.values.first;

    user = {
      'id': 'dev-user-${providerKey}',
      'email': data['email'] ?? 'dev@dartstream.dev',
      'subscriptionStatus': 'active',
      'isSandbox': true,
      'provider': providerKey,
    };

    print('⚡ Simulated login for provider: $providerKey');
  }

  // Generate session
  final sessionId = _generateSessionId();
  _sessions[sessionId] = user;

  return Response.ok(
    jsonEncode({'user': user}),
    headers: {
      'content-type': 'application/json',
      'set-cookie':
          'dartstream_session=$sessionId; HttpOnly; Path=/; SameSite=Lax',
    },
  );
}


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

Future<Response> handleLogout(Request request) async {
  final sessionId = _getSessionId(request);
  if (sessionId != null) {
    _sessions.remove(sessionId);
  }

  return Response.ok(
    jsonEncode({'success': true}),
    headers: {
      'content-type': 'application/json',
      'set-cookie':
          'dartstream_session=; Path=/; Max-Age=0; HttpOnly; SameSite=Lax',
    },
  );
}

/// ===============================
/// MAIN SERVER
/// ===============================
Future<void> main() async {
  print('🚀 Starting DartStream Dev Server (DEV=$kIsDev)');

  // ===============================
  // Initialize Providers (DEV SAFE)
  // ===============================
  final oktaProvider = DSOktaAuthProvider();
  await oktaProvider.initialize({'__dev__': true});

  final transmitProvider = DSTransmitAuthProvider();
  await transmitProvider.initialize({'__dev__': true});

  final entraidProvider = DSEntraIDAuthProvider(
    tenantId: 'mock-tenant-id',
    clientId: 'mock-client-id',
    clientSecret: 'mock-client-secret',
  );
  await entraidProvider.initialize({'__dev__': true});

  final auth0Provider = DSAuth0AuthProvider(
    domain: 'mock-domain',
    clientId: 'mock-client-id',
    clientSecret: 'mock-client-secret',
    audience: 'mock-audience',
  );
  await auth0Provider.initialize({'__dev__': true});

  final cognitoProvider = DSCognitoAuthProvider(
    userPoolId: 'mock-user-pool-id',
    clientId: 'mock-client-id',
    region: 'mock-region',
  );
  await cognitoProvider.initialize({'__dev__': true});

  final fingerprintProvider = DSFingerprintAuthProvider();
  await fingerprintProvider.initialize({'__dev__': true});

  final pingProvider = DSPingAuthProvider();
  await pingProvider.initialize({'__dev__': true});

  // ===============================
  // Register Providers & populate _providers map
  // ===============================
  void registerProvider(String key, DSAuthProvider provider) {
    DSAuthManager.registerProvider(
      key,
      provider,
      DSAuthProviderMetadata(type: key, region: 'global', clientId: 'mock'),
    );
    _providers[key] = provider;
  }

  registerProvider('okta', oktaProvider);
  registerProvider('transmit', transmitProvider);
  registerProvider('entraid', entraidProvider);
  registerProvider('auth0', auth0Provider);
  registerProvider('cognito', cognitoProvider);
  registerProvider('fingerprint', fingerprintProvider);
  registerProvider('ping', pingProvider);

  print('✅ All auth providers initialized & registered');

  // ===============================
  // Shelf Server with CORS support
  // ===============================
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler((Request request) async {
    final path = request.url.path;
    final method = request.method;

    if (method == 'POST' && path == 'auth/sign-in') {
      return handleSignIn(request);
    }

    if (method == 'GET' && path == 'auth/session') {
      return handleSession(request);
    }

    if (method == 'POST' && path == 'auth/logout') {
      return handleLogout(request);
    }

    return Response.notFound(
      jsonEncode({'error': 'Not Found'}),
      headers: {'content-type': 'application/json'},
    );
  });

  final server = await io.serve(handler, 'localhost', 8080);
  print('🔥 Server running at http://${server.address.host}:${server.port}');
}
