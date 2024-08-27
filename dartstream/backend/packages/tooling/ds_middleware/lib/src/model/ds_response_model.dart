import 'ds_request_model.dart';

class DsCustomMiddleWareResponse {
  final int statusCode;
  final Map<String, String> headers;
  final dynamic body;
  final DsCustomMiddleWareRequest? request;

  DsCustomMiddleWareResponse(
    this.statusCode,
    this.headers,
    this.body, {
    this.request,
  });

  /// Creates a successful response with the given body.
  static DsCustomMiddleWareResponse ok(String body) {
    return DsCustomMiddleWareResponse(200, {}, body);
  }

  /// Creates a not found response.
  static DsCustomMiddleWareResponse notFound() {
    return DsCustomMiddleWareResponse(404, {}, 'Not Found');
  }

  /// Creates an unauthorized response.
  static DsCustomMiddleWareResponse unauthorized() {
    return DsCustomMiddleWareResponse(
      401,
      {'www-authenticate': 'Bearer'},
      'Unauthorized',
    );
  }

  /// Creates a copy of the response with optional updates.
  DsCustomMiddleWareResponse copyWith({
    int? statusCode,
    Map<String, String>? headers,
    dynamic body,
    DsCustomMiddleWareRequest? request,
  }) {
    return DsCustomMiddleWareResponse(
      statusCode ?? this.statusCode,
      headers ?? this.headers,
      body ?? this.body,
      request: request ?? this.request,
    );
  }
}