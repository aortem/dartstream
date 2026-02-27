import 'dart:convert';
import 'dart:io';
import 'package:ds_shelf/ds_shelf.dart';

void main() async {
  final router = Router();

  // Route to echo back the parsed body
  router.post('/echo', (Request request) async {
    final parsedBody = request.context['ds_shelf.body'];
    
    if (parsedBody == null) {
      return Response.ok(jsonEncode({
        'status': 'error',
        'message': 'No parsed body found. Did you set the correct Content-Type?',
        'receivedHeaders': request.headers,
      }), headers: {'content-type': 'application/json'});
    }

    return Response.ok(jsonEncode({
      'status': 'success',
      'parsedBody': parsedBody,
      'type': parsedBody.runtimeType.toString(),
    }), headers: {'content-type': 'application/json'});
  });

  // Simple GET route for health check
  router.get('/health', (Request request) {
    return Response.ok('Server is up and running');
  });

  // Serve index.html at root
  router.get('/', (Request request) async {
    final file = File('index.html');
    if (await file.exists()) {
      return Response.ok(await file.readAsString(), headers: {'content-type': 'text/html'});
    }
    return Response.notFound('index.html not found');
  });

  final handler = const Pipeline()
      .addMiddleware(dsShelfCorsMiddleware())
      .addMiddleware(dsShelfBodyParserMiddleware())
      .addHandler(router);

  final server = await serve(handler, InternetAddress.loopbackIPv4, 8081);
  print('Listening on http://localhost:${server.port}');
}
