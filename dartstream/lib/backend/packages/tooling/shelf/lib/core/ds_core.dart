// File: lib/core/ds_core.dart

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class DSCore {
  Handler get handler {
    final router = Router();

    // Define routes here
    router.get('/', (Request req) => Response.ok('Hello, Shelf!'));

    return router;
  }
}
