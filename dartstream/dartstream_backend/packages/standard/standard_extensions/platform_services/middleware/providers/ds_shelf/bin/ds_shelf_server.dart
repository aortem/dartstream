// bin/ds_shelf_server.dart

import 'dart:io';
import 'package:ds_shelf/ds_shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

/// The entry point for your ds_shelf-powered server.
void main(List args) async {
  // 1) Load configuration (e.g. ALLOWED_ORIGINS from .env)
  final config = AppConfig.load();

  // 2) Build your router
  final router = Router()
    ..get('/', (Request req) => Response.ok('Welcome to ds_shelf!'))
  // Add more routes here, or mount external routers:
  // ..mount('/api', yourApiRouter)
  ;

  // 3) Create a pipeline with CORS and logging
  final handler = Pipeline()
      .addMiddleware(dsShelfCorsMiddleware(checker: config.originChecker))
      .addMiddleware(logRequests()) // from package:shelf
      .addHandler(router);

  // 4) Start the HTTP server
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);

  print(
    '🚀 Server listening on http://'
    '${server.address.host}:${server.port}',
  );
}
