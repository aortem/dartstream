import 'dart:convert';
import '../model/ds_request_model.dart';
import '../model/ds_response_model.dart';

class DsHttpHelpers {
  static DsCustomMiddleWareResponse jsonResponse(dynamic data,
      {int statusCode = 200}) {
    return DsCustomMiddleWareResponse(
      statusCode,
      {'Content-Type': 'application/json'},
      json.encode(data),
    );
  }

  static Future<Map<String, dynamic>> parseJsonBody(
      DsCustomMiddleWareRequest request) async {
    if (request.headers['Content-Type'] != 'application/json') {
      throw FormatException('Expecting JSON body');
    }
    return json.decode(request.body as String);
  }

  static DsCustomMiddleWareResponse redirect(String location,
      {int statusCode = 302}) {
    return DsCustomMiddleWareResponse(
      statusCode,
      {'Location': location},
      'Redirecting to $location',
    );
  }

  static String getClientIp(DsCustomMiddleWareRequest request) {
    return request.headers['X-Forwarded-For'] ?? 'Unknown';
  }
}
