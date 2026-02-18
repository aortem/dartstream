import 'package:ds_middleware/ds_custom_middleware.dart';

class DsCustomMiddleWareRouter {
  final List<DsCustomMiddleware> _middlewares;

  DsCustomMiddleWareRouter() : _middlewares = [];

  void addMiddleware(DsCustomMiddleware middleware) {
    _middlewares.add(middleware);
  }

  Future<DsCustomMiddleWareResponse> handle(
      DsCustomMiddleWareRequest request) async {
    Future<DsCustomMiddleWareResponse> Function(DsCustomMiddleWareRequest)
        handler = (req) async {
      return DsCustomMiddleWareResponse.notFound();
    };

    for (var middleware in _middlewares.reversed) {
      handler = (req) async {
        return middleware.handle(req, handler);
      };
    }

    return await handler(request);
  }
}
