import '../model/ds_request_model.dart';
import '../model/ds_response_model.dart';


class Router {
  Future<DsCustomMiddleWareResponse> handleRequest(DsCustomMiddleWareRequest request) async {
    final path = request.uri.path;
    final params = parsePath(path);

    if (path == '/users') {
      return DsCustomMiddleWareResponse.ok('Fetching all users...');
    } else if (path.startsWith('/users/') && path.length > 7) {
      final userId = params['users'];
      if (userId != null) {
        return DsCustomMiddleWareResponse.ok('Fetching user with ID $userId...');
      } else {
        return DsCustomMiddleWareResponse.notFound();
      }
    } else {
      return DsCustomMiddleWareResponse.notFound();
    }
  }

  Map<String, String> parsePath(String path) {
    final parts = path.split('/');
    final params = <String, String>{};

    for (var i = 1; i < parts.length; i += 2) {
      if (i + 1 < parts.length) {
        params[parts[i]] = parts[i + 1];
      }
    }
    return params;
  }
}
