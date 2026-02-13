import 'dart:convert';
import 'dart:io';

void main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('Server running on http://${server.address.address}:${server.port}/');

  await for (HttpRequest request in server) {
    // ✅ Add CORS headers to all responses
    request.response.headers.add('Access-Control-Allow-Origin', '*');
    request.response.headers.add('Access-Control-Allow-Methods', 'POST, GET, OPTIONS');
    request.response.headers.add('Access-Control-Allow-Headers', 'Content-Type');

    // ✅ Handle preflight OPTIONS request
    if (request.method == 'OPTIONS') {
      request.response
        ..statusCode = 200
        ..close();
      continue;
    }

    final path = request.uri.path;
    final method = request.method;

    if (path == '/signup' && method == 'POST') {
      final body = await utf8.decoder.bind(request).join();
      final data = jsonDecode(body);
      print('Signup request: $data');

      request.response
        ..statusCode = 200
        ..write(jsonEncode({'status': 'success', 'message': 'Account created'}))
        ..close();
    } 
    else if (path == '/signin' && method == 'POST') {
      final body = await utf8.decoder.bind(request).join();
      final data = jsonDecode(body);
      print('Signin request: $data');

      request.response
        ..statusCode = 200
        ..write(jsonEncode({'status': 'success', 'token': 'dummy_token'}))
        ..close();
    } 
    else if (path == '/signout' && method == 'POST') {
      print('Signout request');
      request.response
        ..statusCode = 200
        ..write(jsonEncode({'status': 'success'}))
        ..close();
    } 
    else {
      request.response
        ..statusCode = 404
        ..write('Not Found')
        ..close();
    }
  }
}
