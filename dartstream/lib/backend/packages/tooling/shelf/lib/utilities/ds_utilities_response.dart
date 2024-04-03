// Always Import the Utillities Base Class
import 'ds_utilities_base.dart';

//Import Other Packages
import 'dart:convert';
import 'package:shelf/shelf.dart' as shelf;

shelf.Response jsonResponse(Map<String, dynamic> body, {int statusCode = 200}) {
  return shelf.Response(
    statusCode,
    body: json.encode(body),
    headers: {'Content-Type': 'application/json'},
  );
}

shelf.Response errorResponse(String message, {int statusCode = 400}) {
  return jsonResponse({'error': message}, statusCode: statusCode);
}
