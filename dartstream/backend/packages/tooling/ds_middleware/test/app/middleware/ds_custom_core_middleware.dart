import '../models/ds_custom_middleware_model.dart';

abstract class dsCustomMiddleware {
  Future<DsCustomMiddleWareResponse> handle(
      DsCustomMiddleWareRequest request,
      Future<DsCustomMiddleWareResponse> Function(DsCustomMiddleWareRequest)
          next);
}
