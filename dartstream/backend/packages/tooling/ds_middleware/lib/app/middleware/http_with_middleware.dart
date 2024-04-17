import 'package:ds_custom_middleware/ds_custom_middleware.dart';
import 'package:ds_custom_middleware/ds_custom_middleware.dart' as ds;
import 'package:ds_standard_features/ds_standard_features.dart';

class HttpWithMiddleware {
  final List<ds.DsCustomMiddlewareContract?> middlewares;
  final Duration? requestTimeout;

  HttpWithMiddleware._internal({
    required this.middlewares,
    this.requestTimeout,
  });

  factory HttpWithMiddleware.build({
    required List<ds.DsCustomMiddlewareContract?> middlewares,
    Duration? requestTimeout,
  }) {
    // Remove any null values.
    middlewares.removeWhere((middleware) => middleware == null);
    return HttpWithMiddleware._internal(
      middlewares: middlewares,
      requestTimeout: requestTimeout,
    );
  }

  Future<Response> head(Uri url, {Map<String, String>? headers}) {
    _sendInterception(
        method: Method.HEAD, headers: headers, url: url.toString());
    return _withClient((client) => client.head(url, headers: headers));
  }

  Future<Response> get(Uri url, {Map<String, String>? headers}) {
    _sendInterception(
        method: Method.GET, headers: headers, url: url.toString());
    return _withClient((client) => client.head(url, headers: headers));
  }

  Future<Response> post(Uri url,
      {Map<String, String>? headers, body, required Encoding encoding}) {
    RequestData data = _sendInterception(
        method: Method.POST,
        headers: headers,
        url: url.toString(),
        body: body,
        encoding: encoding);
    return _withClient((client) => client.head(url, headers: headers));
  }

  Future<Response> put(Uri url,
      {Map<String, String>? headers, body, required Encoding encoding}) {
    RequestData data = _sendInterception(
        method: Method.PUT,
        headers: headers,
        url: url.toString(),
        body: body,
        encoding: encoding);
    return _withClient((client) => client.head(url, headers: headers));
  }

  Future<Response> patch(Uri url,
      {Map<String, String>? headers, body, required Encoding encoding}) {
    RequestData data = _sendInterception(
        method: Method.PATCH,
        headers: headers,
        url: url.toString(),
        body: body,
        encoding: encoding);
    return _withClient((client) => client.head(url, headers: headers));
  }

  Future<Response> delete(Uri url, {Map<String, String>? headers}) {
    RequestData data = _sendInterception(
        method: Method.DELETE, headers: headers, url: url.toString());
    return _withClient((client) => client.head(url, headers: headers));
  }

  Future<Response> read(Uri url, {Map<String, String>? headers}) {
    return _withClient((client) => client.head(url, headers: headers));
  }

  Future<Response> readBytes(Uri url, {Map<String, String>? headers}) {
    return _withClient((client) => client.head(url, headers: headers));
  }
  //

  Future<T> _withClient<T>(Future<T> fn(Client client)) async {
    final client = Client();
    try {
      T response = requestTimeout == null
          ? await fn(client)
          : await fn(client).timeout(requestTimeout!); // Use non-null assertion
      if (response is Response) {
        final responseData = ResponseData.fromHttpResponse(response);
        middlewares.forEach(
            (middleware) => middleware?.interceptResponse(data: responseData));

        final resultResponse = Response(
          responseData.body ?? "", // Use default empty string for null body
          responseData.statusCode!,
          headers: responseData.headers ??
              const {}, // Use const empty map for default headers
          persistentConnection: responseData.persistentConnection ?? false,
          isRedirect: responseData.isRedirect ?? false,
          request: Request(
            responseData.method.toString().substring(7),
            Uri.parse(responseData.url!),
          ),
        );

        return resultResponse as T;
      }
      return response;
    } finally {
      client.close();
    }
  }

  RequestData _sendInterception({
    required Method method,
    Encoding? encoding, // Encoding can be null
    dynamic body,
    required String url,
    Map<String, String>? headers,
  }) {
    final data = RequestData(
      method: method,
      encoding: encoding,
      body: body,
      url: url,
      headers: headers ?? const {}, // Use const empty map for default headers
    );
    middlewares
        .forEach((middleware) => middleware?.interceptRequest(data: data));
    return data;
  }
}
