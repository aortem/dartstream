// File: dartstream/lib/backend/packages/tooling/shelf/lib/src/ds_internal_middleware.dart

import 'package:shelf/shelf.dart';

// Internal implementation details, not exposed publicly
class DSInternalMiddleware {
  // A static method to log incoming requests
  static void logRequest(Request req) {
    print("Received request for ${req.url}");
  }

  // Example of a middleware function that logs requests
  static Middleware get logRequestsMiddleware => (Handler innerHandler) {
        return (Request request) async {
          logRequest(request); // Log the request
          return innerHandler(
              request); // Proceed to the next handler/middleware
        };
      };
}
