import 'dart:io';

import 'src/model/ds_request_model.dart';
import 'src/model/ds_response_model.dart';

/// Base class for middleware components.
abstract class DsCustomMiddleware {
  /// Handles the incoming request and processes it through the middleware chain.
  Future<DsCustomMiddleWareResponse> handle(
      DsCustomMiddleWareRequest request,
      Future<DsCustomMiddleWareResponse> Function(DsCustomMiddleWareRequest)
          next);
}
