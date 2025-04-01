import 'dart:convert';

class DsCustomMiddleWareRequest {
  final String method;
  final Uri uri;
  final Map<String, String> headers;
  final body;
  final Map<String, String> routeParams; // Added routeParams field
  final Map<String, String> queryParams; // Added queryParams field

  DsCustomMiddleWareRequest(
      this.method, this.uri, this.headers, this.body, this.queryParams,
      {this.routeParams = const {}});
  DsCustomMiddleWareRequest change({Map<String, String>? headers}) {
    // Create a new Request object with the updated headers
    return DsCustomMiddleWareRequest(
        method,
        uri,
        headers ?? this.headers,
        body,
        routeParams: routeParams,
        queryParams);
  }

  // Added new 'copyWith' method
  DsCustomMiddleWareRequest copyWith({
    String? method,
    Uri? uri,
    Map<String, String>? headers,
    dynamic body,
    Map<String, String>? routeParams,
    Map<String, String>? queryParams,
  }) {
    return DsCustomMiddleWareRequest(
      method ?? this.method,
      uri ?? this.uri,
      headers ?? this.headers,
      body ?? this.body,
      routeParams: routeParams ?? this.routeParams,
      queryParams ?? this.queryParams,
    );
  }

  //add read to support body parsing
  Stream<List<int>> read() {
    if (body is String) {
      return Stream.value(utf8.encode(body as String));
    } else if (body is List<int>) {
      return Stream.value(body as List<int>);
    } else {
      throw UnsupportedError('Unsupported body type: ${body.runtimeType}');
    }
  }
}

class DsCustomMiddleWareResponse {
  final int statusCode;
  final Map<String, String> headers;
  final body;
  // Add the request property
  final DsCustomMiddleWareRequest? request;

  DsCustomMiddleWareResponse(this.statusCode, this.headers, this.body,
      {this.request});

  static DsCustomMiddleWareResponse ok(String body) {
    return DsCustomMiddleWareResponse(200, {}, body);
  }

  static DsCustomMiddleWareResponse notFound() {
    return DsCustomMiddleWareResponse(404, {}, 'Not Found');
  }

  static DsCustomMiddleWareResponse unauthorized() {
    return DsCustomMiddleWareResponse(
        401, {'www-authenticate': 'Bearer'}, 'Unauthorized');
  }

  DsCustomMiddleWareResponse copyWith({
    int? statusCode,
    Map<String, String>? headers,
    dynamic body,
    DsCustomMiddleWareRequest? request,
  }) {
    // Create a new Response object with the updated properties
    return DsCustomMiddleWareResponse(
      statusCode ?? this.statusCode,
      headers ?? this.headers,
      body ?? this.body,
      request: request ?? this.request,
    );
  }
}
