import '../model/ds_request_model.dart';
import '../model/ds_response_model.dart';



class NestedRouter {
  Future<DsCustomMiddleWareResponse> handleNestedRequest(DsCustomMiddleWareRequest request) async {
    if (request.uri.path.startsWith('/users/') && request.uri.path.contains('/profile')) {
      final userId = request.uri.path.split('/')[2];
      return DsCustomMiddleWareResponse.ok('Fetching profile for user with ID $userId...');
    } else {
      return DsCustomMiddleWareResponse.notFound();
    }
  }
}
