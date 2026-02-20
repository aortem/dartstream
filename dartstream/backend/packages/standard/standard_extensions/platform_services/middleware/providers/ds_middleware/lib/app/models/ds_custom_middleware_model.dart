import 'dart:convert';

<<<<<<< HEAD
import '../../src/type_handlers/type_handler_registry.dart';
=======
import 'package:ds_middleware/src/type_handlers/type_handler_registry.dart';
>>>>>>> development

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
        queryParams,
        routeParams: routeParams);
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
      queryParams ?? this.queryParams,
      routeParams: routeParams ?? this.routeParams,
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

<<<<<<< HEAD
  /// Deserializes the body to type [T] using [TypeHandlerRegistry].
  T bodyAs<T>() {
    // If body is already T, return it
    if (body is T) return body as T;
    
    // Otherwise try to deserialize
=======
  T bodyAs<T>() {
>>>>>>> development
    return TypeHandlerRegistry.deserialize<T>(body);
  }
}

class DsCustomMiddleWareResponse {
  final int statusCode;
  final Map<String, String> headers;
  final dynamic body;
  // Add the request property
  final DsCustomMiddleWareRequest? request;

  DsCustomMiddleWareResponse(this.statusCode, this.headers, dynamic body,
      {this.request}) : body = TypeHandlerRegistry.serialize(body);

  static DsCustomMiddleWareResponse ok(dynamic body) {
<<<<<<< HEAD
    return DsCustomMiddleWareResponse(200, {}, body);
=======
    dynamic serializedBody = body;
    if (body != null) {
       serializedBody = TypeHandlerRegistry.serialize(body);
    }
    return DsCustomMiddleWareResponse(200, {}, serializedBody);
>>>>>>> development
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
