

import 'app/models/ds_custom_middleware_model.dart';


/// Base class for middleware components.
abstract class DsCustomMiddleware {
  /// Handles the incoming request and processes it through the middleware chain.
  Future<DsCustomMiddleWareResponse> handle(
      DsCustomMiddleWareRequest request,
      Future<DsCustomMiddleWareResponse> Function(DsCustomMiddleWareRequest)
          next);
}
