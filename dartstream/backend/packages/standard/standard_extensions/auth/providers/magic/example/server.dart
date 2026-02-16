import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_magic_auth_provider/ds_magic_auth_provider.dart';

// Use environment variables for keys
final magicPublishableKey = Platform.environment['MAGIC_PUBLISHABLE_KEY'] ?? 'pk_live_1F15F3020DF38574';
final magicSecretKey = Platform.environment['MAGIC_SECRET_KEY'] ?? 'sk_live_YOUR_KEY';

void main() async {
  // Initialize Provider
  final magicProvider = DSMagicAuthProvider(
    publishableKey: magicPublishableKey,
    secretKey: magicSecretKey,
  );
  
  await magicProvider.initialize({
    'publishableKey': magicPublishableKey,
    'secretKey': magicSecretKey,
  });

  DSAuthManager.registerProvider('magic', magicProvider);

  final app = Router();

  // Simple health check
  app.get('/', (Request request) {
    return Response.ok('Magic Auth Backend Running');
  });

  // Login endpoint
  app.post('/login', (Request request) async {
    try {
      final payload = await request.readAsString();
      final data = json.decode(payload);
      final didToken = data['didToken'];

      if (didToken == null) {
        return Response.badRequest(body: 'Missing didToken');
      }

      // Verify token via signIn (which validates against Magic API)
      bool isValid = false;
      
      if (magicSecretKey == 'sk_live_YOUR_KEY') {
        print('Using placeholder secret key. Bypassing Magic API validation for DEMO.');
        isValid = true; // Simulate success for demo
      } else {
        isValid = await magicProvider.verifyToken(didToken);
      }
      
      if (isValid) {
         // Create a user instance just for display/return
         Map<String, dynamic> claims;
         try {
           final parts = didToken.split('.');
           // Basic decoding without signature verification for demo
           if (parts.length == 3) {
             claims = json.decode(utf8.decode(base64Url.decode(base64.normalize(parts[1]))));
           } else {
             throw FormatException('Invalid token format');
           }
         } catch (e) {
           print('Token decoding failed: $e. Using mock user.');
           claims = {
             'iss': 'did:ethr:demo_user',
             'email': 'demo@example.com',
             'publicAddress': '0xDemoAddress'
           };
         }
         
         return Response.ok(json.encode({
           'status': 'success',
           'message': 'Token validated successfully',
           'user': {
             'issuer': claims['iss'],
             'email': claims['email'],
             'publicAddress': claims['publicAddress']
           }
         }), headers: {'content-type': 'application/json'});
      } else {
        return Response.forbidden('Invalid DID Token');
      }
    } catch (e) {
      return Response.internalServerError(body: 'Error: $e');
    }
  });

  // CORS Middleware
  final handler = const Pipeline()
      .addMiddleware((innerHandler) {
        return (request) async {
          if (request.method == 'OPTIONS') {
            return Response.ok('', headers: {
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
              'Access-Control-Allow-Headers': 'Content-Type, Authorization',
            });
          }
          final response = await innerHandler(request);
          return response.change(headers: {
            'Access-Control-Allow-Origin': '*',
          });
        };
      })
      .addMiddleware(logRequests())
      .addHandler(app.call);

  final server = await io.serve(handler, 'localhost', 8080);
  print('Server running on localhost:${server.port}');
}
