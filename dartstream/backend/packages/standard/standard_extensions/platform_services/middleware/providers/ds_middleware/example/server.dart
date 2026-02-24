import 'dart:io';
import 'package:ds_middleware/ds_custom_middleware.dart';

void main() async {
  final interceptor = RequestInterceptor();

  final server = await HttpServer.bind(InternetAddress.anyIPv4, 8080);
  print('Server running on http://${server.address.address}:${server.port}');

  await for (HttpRequest request in server) {
    final dsRequest = DsCustomMiddleWareRequest(
      request.method,
      request.uri,
      request.headers.toString().split('\n').fold<Map<String, String>>({}, (map, line) {
        final parts = line.split(': ');
        if (parts.length == 2) map[parts[0]] = parts[1];
        return map;
      }),
      await utf8.decodeStream(request),
      request.uri.queryParameters,
      context: {'shelf.io.http_request': request},
    );

    final response = await interceptor.handle(dsRequest, (req) async {
      return DsCustomMiddleWareResponse.notFound();
    });

    request.response.statusCode = response.statusCode;
    response.headers.forEach((key, value) {
      request.response.headers.add(key, value);
    });
    
    if (response.body is String) {
       request.response.write(response.body);
    } else if (response.body is List<int>) {
       request.response.add(response.body as List<int>);
    } else if (response.body != null) {
       request.response.write(response.body.toString());
    }

    await request.response.close();
  }
}
