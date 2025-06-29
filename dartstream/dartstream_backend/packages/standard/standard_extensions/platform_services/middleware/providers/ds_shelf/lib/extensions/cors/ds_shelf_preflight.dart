// lib/src/cors/ds_preflight.dart

import 'package:shelf/shelf.dart';
import 'ds_shelf_cors_defaults.dart';

/// Builds the standard CORS preflight headers for the given [origin].
Map<String, List<String>> _buildPreflightHeaders(String origin) {
  return {
    dsAccessControlAllowOrigin: [origin],
    dsAccessControlExposeHeaders: [''],
    dsAccessControlAllowCredentials: ['true'],
    dsAccessControlAllowHeaders: [dsDefaultAllowHeaders.join(',')],
    dsAccessControlAllowMethods: [dsDefaultAllowMethods.join(',')],
    dsAccessControlMaxAge: ['86400'],
    dsVary: ['Origin'],
  };
}

/// Generates a CORS preflight (OPTIONS) [Response] using default headers.
Response dsCorsPreflightResponse(Request request) {
  final origin = request.headers[dsOriginHeader];
  if (origin == null) {
    // No Origin header → not a valid CORS preflight
    return Response(400, body: 'Missing Origin header');
  }
  return Response.ok(null, headers: _buildPreflightHeaders(origin));
}
