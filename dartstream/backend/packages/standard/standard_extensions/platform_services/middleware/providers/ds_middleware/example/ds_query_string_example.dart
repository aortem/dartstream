import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

import '../lib/app/models/ds_custom_middleware_model.dart';
import '../lib/routing/ds_query_string_handler.dart';

void main() async {
  final router = Router();
  final queryHandler = DsQueryStringHandler();

  router.get('/products', (Request request) {
    final customRequest =
        DsCustomMiddleWareRequest.fromShelf(request);

    final category =
        queryHandler.getString(customRequest, 'category');
    final minPrice =
        queryHandler.getDouble(customRequest, 'minPrice');
    final maxPrice =
        queryHandler.getDouble(customRequest, 'maxPrice');
    final limit =
        queryHandler.getInt(customRequest, 'limit', defaultValue: 10);
    final featured =
        queryHandler.getBool(customRequest, 'featured');

    return Response.ok(
      {
        'category': category,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
        'limit': limit,
        'featured': featured,
      }.toString(),
      headers: {'Content-Type': 'application/json'},
    );
  });

  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(router);

  final server = await io.serve(handler, 'localhost', 8081);

  print('🚀 Server running at http://${server.address.host}:${server.port}');
}