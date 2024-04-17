import 'dart:convert';
import 'package:http/http.dart' as http; // Alias http for clarity

import '../middleware/ds_custom_middleware_methods.dart';

class ResponseData {
  final String? url;
  final int? statusCode;
  final Method? method;
  final Map<String, String>? headers;
  final String? body;
  final List<int>? bodyBytes;
  final int? contentLength;
  final bool? isRedirect;
  final bool? persistentConnection;

  ResponseData({
    this.method,
    this.url,
    this.statusCode,
    this.headers,
    this.body,
    this.bodyBytes,
    this.contentLength,
    this.isRedirect,
    this.persistentConnection,
  });

  factory ResponseData.fromHttpResponse(http.Response response) {
    return ResponseData(
      statusCode: response.statusCode,
      headers: response.headers,
      body: response.body,
      bodyBytes: response.bodyBytes,
      contentLength: response.contentLength,
      isRedirect: response.isRedirect,
      url: response.request?.url.toString(),
      method: methodFromString(response.request!.method),
      persistentConnection: response.persistentConnection,
    );
  }
}
