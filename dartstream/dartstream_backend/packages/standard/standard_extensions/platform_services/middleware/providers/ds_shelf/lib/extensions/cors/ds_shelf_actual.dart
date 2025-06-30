// lib/src/cors/ds_actual.dart

import 'package:shelf/shelf.dart';
import 'ds_shelf_cors_defaults.dart';

/// Builds the standard CORS headers to add to real responses for [origin].
Map<String, List<String>> _buildActualHeaders(String origin) {
  return {
    dsAccessControlAllowOrigin: [origin],
    dsAccessControlExposeHeaders: [''],
    dsAccessControlAllowCredentials: ['true'],
    dsAccessControlAllowHeaders: [dsDefaultAllowHeaders.join(',')],
    dsAccessControlAllowMethods: [dsDefaultAllowMethods.join(',')],
    dsVary: ['Origin'],
  };
}

/// Applies CORS headers to a non-OPTIONS [response] using the given [origin].
Response dsShelfCorsApplyActual(Response response, String origin) {
  return response.change(headers: _buildActualHeaders(origin));
}
