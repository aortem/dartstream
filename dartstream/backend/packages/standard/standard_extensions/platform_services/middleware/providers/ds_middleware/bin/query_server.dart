import 'dart:io';
import 'package:ds_shelf/extensions/body_parser/ds_shelf_body_parser.dart';
import 'package:ds_shelf/extensions/cors/ds_shelf_cors_middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import '../lib/src/query_string/product_router.dart';

void main() async {
  final router = Router();

  // Mount product router
  router.mount('/', getProductRouter());

  final handler = const Pipeline()
      .addMiddleware(dsShelfCorsMiddleware())
      .addMiddleware(dsShelfBodyParserMiddleware())
      .addHandler(router);

  final server = await serve(handler, InternetAddress.loopbackIPv4, 8081);
  print('Server running on http://localhost:${server.port}');
}