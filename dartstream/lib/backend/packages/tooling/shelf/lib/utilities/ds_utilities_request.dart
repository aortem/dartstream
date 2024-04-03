// Always Import the Utillities Base Class
import 'ds_utilities_base.dart';

//Import Other Packages

import 'package:shelf/shelf.dart' as shelf;

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
