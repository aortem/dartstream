import 'dart:convert' as convert;
import 'dart:typed_data';

import 'package:ds_standard_features/ds_standard_features.dart';
import 'package:http/http.dart' as http;

import 'package:http/io_client.dart';

import 'middleware_contract.dart';

///Don't forget to close the client once you are done, as a client keeps
///the connection alive with the server.
class HttpClientWithMiddleware extends http.BaseClient {
  List<DsCustomMiddlewareContract> middlewares;
  Duration requestTimeout;

  final IOClient _client = IOClient();

  HttpClientWithMiddleware._internal(
      {required this.middlewares, required this.requestTimeout});

  factory HttpClientWithMiddleware.build({
    required List<DsCustomMiddlewareContract> middlewares,
    required Duration requestTimeout,
  }) {
    //Remove any value that is null.
    middlewares.removeWhere((middleware) => middleware == null);
    return HttpClientWithMiddleware._internal(
      middlewares: middlewares,
      requestTimeout: requestTimeout,
    );
  }

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      _sendUnstreamed("HEAD", url, headers);
  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) =>
      _sendUnstreamed("GET", url, headers);

  @override
  Future<Response> post(Uri url,
      {Map<String, String>? headers,
      Object? body,
      convert.Encoding? encoding}) async {
    return await _sendUnstreamed("POST", url, headers, body, encoding);
  }

  @override
  Future<Response> put(url,
          {Map<String, String>? headers, body, convert.Encoding? encoding}) =>
      _sendUnstreamed("PUT", url, headers, body, encoding);

  @override
  Future<Response> patch(url,
          {Map<String, String>? headers, body, convert.Encoding? encoding}) =>
      _sendUnstreamed("PATCH", url, headers, body, encoding);

  @override
  Future<Response> delete(Uri url,
          {Map<String, String>? headers,
          Object? body,
          convert.Encoding? encoding}) =>
      _sendUnstreamed('DELETE', url, headers, body, encoding);

  @override
  Future<String> read(url, {Map<String, String>? headers}) {
    return get(url, headers: headers).then((response) {
      _checkResponseSuccess(url, response);
      return response.body;
    });
  }

  @override
  Future<Uint8List> readBytes(url, {Map<String, String>? headers}) {
    return get(url, headers: headers).then((response) {
      _checkResponseSuccess(url, response);
      return response.bodyBytes;
    });
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) => _client.send(request);
// Use Encoding.utf8 directly

  Future<Response> _sendUnstreamed(
      String method, Uri url, Map<String, String>? headers,
      [Object? body, convert.Encoding? encoding]) async {
    var request = Request(method, url);

    if (headers != null) request.headers.addAll(headers);
    if (encoding != null) request.encoding = encoding;
    if (body != null) {
      if (body is String) {
        request.body = body;
      } else if (body is List) {
        request.bodyBytes = body.cast<int>();
      } else if (body is Map) {
        request.bodyFields = body.cast<String, String>();
      } else {
        throw ArgumentError('Invalid request body "$body".');
      }
    }

    return Response.fromStream(await send(request));
  }

  void _checkResponseSuccess(url, Response response) {
    if (response.statusCode < 400) return;
    var message = "Request to $url failed with status ${response.statusCode}";
    if (response.reasonPhrase != null) {
      message = "$message: ${response.reasonPhrase}";
    }
    if (url is String) url = Uri.parse(url);
    throw new ClientException("$message.", url);
  }

  @override
  void close() {
    _client.close();
  }
}
