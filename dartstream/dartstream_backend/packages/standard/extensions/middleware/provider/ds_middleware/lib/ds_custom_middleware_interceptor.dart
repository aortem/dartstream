import 'dart:io';

import 'ds_custom_middleware_base.dart';
import 'src/model/ds_request_model.dart';
import 'src/model/ds_response_model.dart';
import 'src/routing/dynamic_routing.dart';
import 'src/routing/index_routing.dart';
import 'src/routing/nested_router.dart';
import 'src/routing/print_router.dart';

class RequestInterceptor extends DsCustomMiddleware {
  final Router _router = Router();
  final IndexRouter _indexRouter = IndexRouter();
  final PrintRouter _printRouter = PrintRouter();
  final NestedRouter _nestedRouter = NestedRouter();

  @override
  Future<DsCustomMiddleWareResponse> handle(
    DsCustomMiddleWareRequest request,
    Future<DsCustomMiddleWareResponse> Function(DsCustomMiddleWareRequest) next,
  ) async {
    // Choose which router to use based on the request path
    if (request.uri.path == '/' || request.uri.path == '/index') {
      return _indexRouter.handleIndexRequest(request);
    } else if (request.uri.path.startsWith('/print')) {
      return _printRouter.handlePrintRequest(request);
    } else if (request.uri.path.startsWith('/users/')) {
      return _nestedRouter.handleNestedRequest(request);
    } else {
      return _router.handleRequest(request);
    }
  }
}
