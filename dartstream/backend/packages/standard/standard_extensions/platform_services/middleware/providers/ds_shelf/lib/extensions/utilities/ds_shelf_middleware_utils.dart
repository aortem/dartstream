// lib/src/utilities/ds_shelf_middleware_utils.dart
import 'package:shelf/shelf.dart';

/// Example custom middleware: tags each request with foo=bar.
Middleware dsShelfCustomTagMiddleware() {
  return (Handler inner) {
    return (Request request) async {
      final modified = request.change(context: {'foo': 'bar'});
      return await inner(modified);
    };
  };
}
