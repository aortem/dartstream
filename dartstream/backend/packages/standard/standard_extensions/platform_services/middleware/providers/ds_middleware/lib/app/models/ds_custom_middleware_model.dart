import 'dart:convert';

import 'package:ds_middleware/src/type_handlers/type_handler_registry.dart';

class DsCustomMiddleWareRequest {
  final String method;
  final Uri uri;
  final Map<String, String> headers;
  final body;
  final Map<String, dynamic>? routeParams;
  final Map<String, String> queryParams;
  final Map<String, dynamic> context;

  DsCustomMiddleWareRequest({
    required this.method,
    required this.uri,
    required this.headers,
    this.body,
    this.routeParams = const {},
    this.queryParams = const {},
    this.context = const {},
  });

  DsCustomMiddleWareRequest change({
    Map<String, String>? headers,
    dynamic body,
  }) {
    return DsCustomMiddleWareRequest(
      method: method,
      uri: uri,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      routeParams: routeParams,
      queryParams: queryParams,
      context: context,
    );
  }

  DsCustomMiddleWareRequest copyWith({
    String? method,
    Uri? uri,
    Map<String, String>? headers,
    dynamic body,
    Map<String, dynamic>? routeParams,
    Map<String, String>? queryParams,
    Map<String, dynamic>? context,
  }) {
    return DsCustomMiddleWareRequest(
      method: method ?? this.method,
      uri: uri ?? this.uri,
      headers: headers ?? this.headers,
      body: body ?? this.body,
      routeParams: routeParams ?? this.routeParams,
      queryParams: queryParams ?? this.queryParams,
      context: context ?? this.context,
    );
  }

  Stream<List<int>> read() {
    if (body is String) {
      return Stream.value(utf8.encode(body as String));
    } else if (body is List<int>) {
      return Stream.value(body as List<int>);
    } else if (body == null) {
      return Stream.empty();
    } else {
      throw UnsupportedError('Unsupported body type: ${body.runtimeType}');
    }
  }

  T bodyAs<T>() {
    if (body is T) return body as T;
    return TypeHandlerRegistry.deserialize<T>(body);
  }
}

class DsCustomMiddleWareResponse {
  final int statusCode;
  final Map<String, String> headers;
  final dynamic body;
  final DsCustomMiddleWareRequest? request;

  DsCustomMiddleWareResponse(
    this.statusCode,
    this.headers,
    dynamic body, {
    this.request,
  }) : body = TypeHandlerRegistry.serialize(body);

  static DsCustomMiddleWareResponse ok(dynamic body) {
    return DsCustomMiddleWareResponse(200, {}, body);
  }

  static DsCustomMiddleWareResponse notFound() {
    return DsCustomMiddleWareResponse(404, {}, 'Not Found');
  }

  static DsCustomMiddleWareResponse unauthorized() {
    return DsCustomMiddleWareResponse(401, {
      'www-authenticate': 'Bearer',
    }, 'Unauthorized');
  }

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
