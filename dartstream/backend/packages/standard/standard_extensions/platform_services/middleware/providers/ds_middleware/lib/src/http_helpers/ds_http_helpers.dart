import 'dart:convert';
import 'dart:io';

import '../../app/models/ds_custom_middleware_model.dart';

class DsHttpHelpers {
  /// -------------------
  /// Core HTTP Responses
  /// -------------------

  /// 200 OK
  static DsCustomMiddleWareResponse ok(
    dynamic body, {
    Map<String, String>? headers,
  }) {
    return DsCustomMiddleWareResponse(200, headers ?? {}, body);
  }

  /// 201 Created
  static DsCustomMiddleWareResponse created(
    dynamic body, {
    Map<String, String>? headers,
  }) {
    return DsCustomMiddleWareResponse(201, headers ?? {}, body);
  }

  /// 400 Bad Request
  static DsCustomMiddleWareResponse badRequest(
    dynamic body, {
    Map<String, String>? headers,
  }) {
    return DsCustomMiddleWareResponse(400, headers ?? {}, body);
  }

  /// 401 Unauthorized
  static DsCustomMiddleWareResponse unauthorized({
    String message = 'Unauthorized',
    Map<String, String>? headers,
  }) {
    return DsCustomMiddleWareResponse(401, {
      'www-authenticate': 'Bearer',
      ...?headers,
    }, message);
  }

  /// 404 Not Found
  static DsCustomMiddleWareResponse notFound({
    String message = 'Not Found',
    Map<String, String>? headers,
  }) {
    return DsCustomMiddleWareResponse(404, headers ?? {}, message);
  }

  /// 500 Internal Server Error
  static DsCustomMiddleWareResponse internalError({
    String message = 'Internal Server Error',
    Map<String, String>? headers,
  }) {
    return DsCustomMiddleWareResponse(500, headers ?? {}, message);
  }

  /// -------------------
  /// JSON Response
  /// -------------------
  static DsCustomMiddleWareResponse jsonResponse(
    dynamic data, {
    int statusCode = 200,
    Map<String, String>? headers,
  }) {
    return DsCustomMiddleWareResponse(statusCode, {
      'Content-Type': 'application/json',
      ...?headers,
    }, jsonEncode(data));
  }

  /// Standardized Error Response
  static DsCustomMiddleWareResponse error({
    required String message,
    int statusCode = 500,
    Map<String, String>? headers,
  }) {
    return jsonResponse(
      {'status': statusCode, 'error': message},
      statusCode: statusCode,
      headers: headers,
    );
  }

  /// -------------------
  /// CORS Helper
  /// -------------------
  static DsCustomMiddleWareResponse withCors(
    DsCustomMiddleWareResponse response, {
    String origin = '*',
    String methods = 'GET, POST, PUT, DELETE',
    String allowHeaders = 'Content-Type, Authorization',
  }) {
    return response.copyWith(
      headers: {
        ...response.headers,
        'Access-Control-Allow-Origin': origin,
        'Access-Control-Allow-Methods': methods,
        'Access-Control-Allow-Headers': allowHeaders,
      },
    );
  }

  /// -------------------
  /// Caching Helper
  /// -------------------
  static DsCustomMiddleWareResponse withCache(
    DsCustomMiddleWareResponse response, {
    int maxAgeSeconds = 3600,
    bool isPrivate = false,
  }) {
    final cacheControl = isPrivate ? 'private' : 'public';
    return response.copyWith(
      headers: {
        ...response.headers,
        'Cache-Control': '$cacheControl, max-age=$maxAgeSeconds',
      },
    );
  }

  /// -------------------
  /// File & Stream Responses
  /// -------------------

  /// File download response
  static DsCustomMiddleWareResponse file(
    File file, {
    String contentType = 'application/octet-stream',
    String? fileName,
    Map<String, String>? headers,
  }) {
    final defaultHeaders = {
      'Content-Type': contentType,
      'Content-Length': file.lengthSync().toString(),
      if (fileName != null)
        'Content-Disposition': 'attachment; filename="$fileName"',
      ...?headers,
    };

    return DsCustomMiddleWareResponse(200, defaultHeaders, file.openRead());
  }

  /// Stream response (large datasets)
  static DsCustomMiddleWareResponse stream(
    Stream<List<int>> stream, {
    String contentType = 'application/octet-stream',
    Map<String, String>? headers,
  }) {
    return DsCustomMiddleWareResponse(200, {
      'Content-Type': contentType,
      ...?headers,
    }, stream);
  }

  /// -------------------
  /// Header Utilities
  /// -------------------

  /// Merge additional headers into existing response
  static DsCustomMiddleWareResponse withHeaders(
    DsCustomMiddleWareResponse response,
    Map<String, String> newHeaders,
  ) {
    return response.copyWith(headers: {...response.headers, ...newHeaders});
  }

  /// -------------------
  /// Old Helpers (for backward compatibility)
  /// -------------------

  /// Parse JSON body from request
  static Future<Map<String, dynamic>> parseJsonBody(
    DsCustomMiddleWareRequest request,
  ) async {
    if (request.headers['Content-Type'] != 'application/json') {
      throw FormatException('Expecting JSON body');
    }
    return json.decode(request.body as String);
  }

  /// Redirect response
  static DsCustomMiddleWareResponse redirect(
    String location, {
    int statusCode = 302,
  }) {
    return DsCustomMiddleWareResponse(statusCode, {
      'Location': location,
    }, 'Redirecting to $location');
  }

  /// Get client IP from request
  static String getClientIp(DsCustomMiddleWareRequest request) {
    return request.headers['X-Forwarded-For'] ?? 'Unknown';
  }
}
