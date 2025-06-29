// lib/src/utilities/ds_shelf_request_utils.dart
import 'package:shelf/shelf.dart';

/// Extract query parameters from a request.
Map<String, String> dsShelfParseQueryParams(Request request) {
  return request.url.queryParameters;
}

/// Extract Bearer token from Authorization header.
String? dsShelfExtractBearerToken(Request request) {
  final header = request.headers['authorization'];
  if (header != null && header.toLowerCase().startsWith('bearer ')) {
    return header.substring(7);
  }
  return null;
}
