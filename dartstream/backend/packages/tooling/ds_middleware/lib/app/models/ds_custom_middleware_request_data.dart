import 'dart:convert';

import '../middleware/ds_custom_middleware_methods.dart';

enum Encoding {
  json,
  urlEncoded,
  none,
  utf8
} // Assuming you have an Encoding enum

class RequestData {
  final Method method;
  final String url;
  final Map<String, String>? headers; // Allow headers to be null
  final Object? body; // More generic type for body
  final Encoding? encoding; // Allow encoding to be null

  RequestData({
    required this.method,
    required this.url,
    this.headers,
    this.body,
    this.encoding,
  });
}
