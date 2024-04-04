// Import Top Level Package
import 'package:ds_shelf/ds_shelf.dart' as shelf; //Coverage for shelf
import 'package:ds_shelf/ds_shelf.dart'; //Coverage for other packages

//Import other core packages

Map<String, dynamic> parseQueryParams(shelf.Request request) {
  return request.url.queryParameters;
}

String? extractBearerToken(shelf.Request request) {
  final authHeader = request.headers['Authorization'];
  if (authHeader != null && authHeader.startsWith('Bearer ')) {
    return authHeader.substring(7);
  }
  return null;
}
