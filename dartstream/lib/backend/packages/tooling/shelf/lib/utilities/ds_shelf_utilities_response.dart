// Import Top Level Package
import 'package:ds_shelf/ds_shelf.dart' as shelf; //Coverage for shelf
import 'package:ds_shelf/ds_shelf.dart'; //Coverage for other packages

//Import other core packages
import 'dart:convert';

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
