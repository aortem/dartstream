// lib/src/cors/ds_cors_middleware.dart

import 'package:shelf/shelf.dart';
import 'ds_shelf_cors_defaults.dart';
import 'ds_shelf_origin_checker.dart';
import 'ds_shelf_preflight.dart';
import 'ds_shelf_actual.dart';

/// CORS middleware: handles preflight and adds CORS headers to actual requests.
///
/// [checker] determines if an incoming Origin is allowed.
Middleware dsShelfCorsMiddleware({
  DsShelfOriginChecker checker = dsShelfOriginAllowAll,
}) {
  return (Handler inner) {
    return (Request request) async {
      final origin = request.headers[dsShelfOriginHeader];
      if (origin == null || !checker(origin)) {
        // Not a CORS request or origin disallowed: pass through
        return inner(request);
      }
      if (request.method == 'OPTIONS') {
        // Preflight request
        return dsShelfCorsPreflightResponse(request);
      }
      // Actual request
      final response = await inner(request);
      return dsShelfCorsApplyActual(response, origin);
    };
  };
}
