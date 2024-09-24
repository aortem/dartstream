import 'dart:convert';
import '../model/ds_request_model.dart';

class DsBodyParser {
  static Future<dynamic> parse(DsCustomMiddleWareRequest request) async {
    final contentType = request.headers['Content-Type'];
    if (contentType == null) {
      throw FormatException('Content-Type header is missing');
    }

    if (contentType.contains('application/json')) {
      return _parseJson(request.body as String);
    } else if (contentType.contains('application/x-www-form-urlencoded')) {
      return _parseFormData(request.body as String);
    } else if (contentType.contains('multipart/form-data')) {
      return _parseMultipartFormData(request.body as String);
    } else {
      throw UnimplementedError('Unsupported Content-Type: $contentType');
    }
  }

  static dynamic _parseJson(String body) {
    return json.decode(body);
  }

  static Map<String, String> _parseFormData(String body) {
    return Uri.splitQueryString(body);
  }

  static Future<Map<String, dynamic>> _parseMultipartFormData(
      String body) async {
    // This is a simplified implementation. In a real-world scenario,
    // you'd need to handle file uploads and more complex parsing.
    final result = <String, dynamic>{};
    final parts = body.split('&');
    for (var part in parts) {
      final keyValue = part.split('=');
      if (keyValue.length == 2) {
        result[keyValue[0]] = Uri.decodeComponent(keyValue[1]);
      }
    }
    return result;
  }
}
