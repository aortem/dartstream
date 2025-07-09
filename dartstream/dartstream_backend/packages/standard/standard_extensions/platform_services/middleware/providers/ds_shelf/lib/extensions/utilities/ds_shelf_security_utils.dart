// lib/src/utilities/ds_shelf_security_utils.dart
import 'package:shelf/shelf.dart';

/// Simple API key check middleware.
Middleware dsShelfApiKeyMiddleware(String expectedKey) {
  return (Handler inner) {
    return (Request request) async {
      final apiKey = request.headers['x-api-key'];
      if (apiKey != expectedKey) {
        return Response.forbidden('Invalid API key');
      }
      return await inner(request);
    };
  };
}
