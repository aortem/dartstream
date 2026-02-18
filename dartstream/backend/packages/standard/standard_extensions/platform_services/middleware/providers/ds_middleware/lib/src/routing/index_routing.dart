import '../../app/models/ds_custom_middleware_model.dart';



class IndexRouter {
  Future<DsCustomMiddleWareResponse> handleIndexRequest(DsCustomMiddleWareRequest request) async {
    if (request.uri.path == '/' || request.uri.path == '/index') {
      return DsCustomMiddleWareResponse.ok('Welcome to the homepage!');
    } else {
      return DsCustomMiddleWareResponse.notFound();
    }
  }
}
