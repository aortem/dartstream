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
  bool allowCredentials = false,
  List<String>? exposedHeaders,
}) {
  return (Handler inner) {
    return (Request request) async {
      final origin = request.headers[dsShelfOriginHeader];

      // Not a CORS request
      if (origin == null) {
        return inner(request);
      }

      // Origin not allowed
      if (!checker(origin)) {
        return inner(request);
      }

      // Preflight request
      if (request.method.toUpperCase() == 'OPTIONS') {
        return dsShelfCorsPreflightResponse(
          request,
          allowCredentials: allowCredentials,
        );
      }

      // Actual request
      final response = await inner(request);

      return dsShelfCorsApplyActual(
        response,
        origin,
        allowCredentials: allowCredentials,
        exposedHeaders: exposedHeaders,
      );
    };
  };
}