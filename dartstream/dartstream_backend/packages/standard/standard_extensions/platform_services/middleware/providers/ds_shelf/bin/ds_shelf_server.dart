// bin/ds_shelf_server.dart

import 'dart:io';
import 'package:ds_shelf/ds_shelf.dart';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

/// The entry point for your ds_shelf-powered server.
void main(List args) async {
  // 1) Load configuration
  final config = AppConfig.load();

  // 2) Instantiate core server
  final core = DSShelfCore();

  // 3) Register extension middleware (CORS)
  core.addMiddleware(dsShelfCorsMiddleware(checker: config.originChecker));

  // 4) Add application routes
  core.addGetRoute('/', (Request req) => Response.ok('Welcome to ds_shelf!'));

  // 5) Start the HTTP server
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await shelf_io.serve(
    core.handler,
    InternetAddress.anyIPv4,
    port,
  );

  print('🚀 Server listening on http://${server.address.host}:${server.port}');
}
