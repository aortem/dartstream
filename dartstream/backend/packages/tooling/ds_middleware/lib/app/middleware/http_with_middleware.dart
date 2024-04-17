import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';

import 'middleware_contract.dart';


class HttpWithMiddleware {
  List<DsCustomMiddlewareContract> middlewares;
  Duration requestTimeout;


  HttpClientWithMiddleware._internal({required this.middlewares, required this.requestTimeout});

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
  Future<Response> head(url, {Map<String, String> headers}) {
    _sendInterception(method: Method.HEAD, headers: headers, url: url);
    return _withClient((client) => client.head(url, headers: headers));
  }

  Future<Response> get(url, {Map<String, String> headers}) {
    RequestData data =
        _sendInterception(method: Method.GET, headers: headers, url: url);
    return _withClient((client) => client.get(data.url, headers: data.headers));
  }

  Future<Response> post(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    RequestData data = _sendInterception(
        method: Method.POST,
        headers: headers,
        url: url,
        body: body,
        encoding: encoding);
    return _withClient((client) => client.post(data.url,
        headers: data.headers, body: data.body, encoding: data.encoding));
  }

  Future<Response> put(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    RequestData data = _sendInterception(
        method: Method.PUT,
        headers: headers,
        url: url,
        body: body,
        encoding: encoding);
    return _withClient((client) => client.put(data.url,
        headers: data.headers, body: data.body, encoding: data.encoding));
  }

  Future<Response> patch(url,
      {Map<String, String> headers, body, Encoding encoding}) {
    RequestData data = _sendInterception(
        method: Method.PATCH,
        headers: headers,
        url: url,
        body: body,
        encoding: encoding);
    return _withClient((client) => client.patch(data.url,
        headers: data.headers, body: data.body, encoding: data.encoding));
  }

  Future<Response> delete(url, {Map<String, String> headers}) {
    RequestData data =
        _sendInterception(method: Method.DELETE, headers: headers, url: url);
    return _withClient(
        (client) => client.delete(data.url, headers: data.headers));
  }

  Future<String> read(url, {Map<String, String> headers}) {
    return _withClient((client) => client.read(url, headers: headers));
  }

  Future<Uint8List> readBytes(url, {Map<String, String> headers}) =>
      _withClient((client) => client.readBytes(url, headers: headers));
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


  Future<T> _withClient<T>(Future<T> fn(Client client)) async {
    var client = new Client();
    try {
      T response = requestTimeout == null
          ? await fn(client)
          : await fn(client).timeout(requestTimeout);
      if (response is Response) {
        var responseData = ResponseData.fromHttpResponse(response);
        middlewares?.forEach(
            (middleware) => middleware.interceptResponse(data: responseData));

        Response resultResponse = Response(
          responseData.body,
          responseData.statusCode,
          headers: responseData.headers,
          persistentConnection: responseData.persistentConnection,
          isRedirect: responseData.isRedirect,
          request: Request(
            responseData.method.toString().substring(7),
            Uri.parse(responseData.url),
          ),
        );

        return resultResponse as T;
      }
      return response;
    } finally {
      client.close();
    }
  }
}
