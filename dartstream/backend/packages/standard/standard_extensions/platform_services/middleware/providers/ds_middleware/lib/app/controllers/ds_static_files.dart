import 'dart:io';

class Handler {
  void handleRequest(HttpRequest request) {
    // Handle the request logic here
    request.response
      ..write('Hello from Handler')
      ..close();
  }
}

Future<HttpServer> run(Handler handler, InternetAddress ip, int port) async {
  final server = await HttpServer.bind(ip, port);
  print('Server running on ${ip.address}:$port');

  server.listen((HttpRequest request) {
    final uri = request.uri;
    if (uri.path.startsWith('/images')) {
      final filePath = uri.path.replaceFirst('/images', '');
      final file = File('${Directory.current.path}/api/images$filePath');
      file.exists().then((exists) {
        if (exists) {
          // Serve the file directly
          file.openRead().pipe(request.response);
        } else {
          // File not found
          request.response
            ..statusCode = HttpStatus.notFound
            ..write('File not found')
            ..close();
        }
      });
    } else {
      // Pass other requests to the provided handler
      handler.handleRequest(request);
    }
  });

  return server;
}

void main() async {
  final handler = Handler();
  final ip = InternetAddress.anyIPv4; // Change to specific IP if needed
  final port = 8080; // Change to desired port

  await run(handler, ip, port);
}
