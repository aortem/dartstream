class DsCustomMiddleWareRequest {
  final String method;
  final Uri uri;
  final Map<String, String> headers;
  final dynamic body;

  DsCustomMiddleWareRequest(
      this.method, this.uri, this.headers, this.body);

  /// Creates a new request with updated headers.
  DsCustomMiddleWareRequest change({Map<String, String>? headers}) {
    return DsCustomMiddleWareRequest(
      method,
      uri,
      headers ?? this.headers,
      body,
    );
  }
}