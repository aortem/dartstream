import 'dart:io'; //Part Of The Dart SDK Core

void main() async {
  final server = await HttpServer.bind('localhost', 8080);
  print('Server running on localhost:${server.port}');

  server.listen((HttpRequest request) {
    if (request.uri.path == '/') {
      handleHtmlRequest(request);
    } else {
      request.response
        ..statusCode = HttpStatus.notFound
        ..write('Not Found')
        ..close();
    }
  });
}

void handleHtmlRequest(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.ok
    ..headers.contentType = ContentType.html
    ..write('<html><body><h1>Welcome, To the main page!</h1></body></html>')
    ..close();
}
