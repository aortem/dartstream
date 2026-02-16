// lib/src/utilities/ds_shelf_response_utils.dart
import 'dart:convert';
import 'package:shelf/shelf.dart';

/// Wrap data in a JSON response.
Response dsShelfJsonResponse(Object data, {int statusCode = 200}) {
  final body = data is String ? data : json.encode(data);
  return Response(
    statusCode,
    body: body,
    headers: {'content-type': 'application/json'},
  );
}

/// Wrap an error message in a JSON response.
Response dsShelfErrorResponse(String message, {int statusCode = 400}) {
  return dsShelfJsonResponse({'error': message}, statusCode: statusCode);
}
