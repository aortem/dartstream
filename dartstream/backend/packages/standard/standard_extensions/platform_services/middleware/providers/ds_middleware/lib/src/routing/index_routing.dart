import '../model/ds_request_model.dart';
import '../model/ds_response_model.dart';


class IndexRouter {
  Future<DsCustomMiddleWareResponse> handleIndexRequest(DsCustomMiddleWareRequest request) async {
    if (request.uri.path == '/' || request.uri.path == '/index') {
      return DsCustomMiddleWareResponse.ok('Welcome to the homepage!');
    } else {
      return DsCustomMiddleWareResponse.notFound();
    }
  }
}
