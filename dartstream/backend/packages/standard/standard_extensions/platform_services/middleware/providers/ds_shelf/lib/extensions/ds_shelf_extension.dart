import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

import '../core/ds_shelf_core.dart';

abstract class DSStaticFileHanlder extends DSShelfCore {}

extension StaticFileHandler on Router {
  /// Serves files from [directoryPath] under [routePrefix].
  ///
  /// Example:
  /// - `routePrefix: '/assets'` serves `/assets/app.css` from `<directoryPath>/app.css`.
  /// - `routePrefix: '/'` serves static files from the root path.
  void serveStaticFiles(
    String directoryPath, {
    String routePrefix = '/',
    String defaultDocument = 'index.html',
    bool listDirectories = false,
    bool serveFilesOutsidePath = false,
  }) {
    final normalizedPrefix = _normalizeRoutePrefix(routePrefix);

    final staticHandler = createStaticHandler(
      directoryPath,
      defaultDocument: defaultDocument,
      listDirectories: listDirectories,
      serveFilesOutsidePath: serveFilesOutsidePath,
    );

    if (normalizedPrefix == '/') {
      mount('/', staticHandler);
      return;
    }

    // Mounted handlers require a trailing slash in the route prefix.
    mount('$normalizedPrefix/', staticHandler);

    // Normalize prefix requests without trailing slash.
    get(normalizedPrefix, (Request request) {
      return Response.movedPermanently('${request.requestedUri.path}/');
    });
  }
}

String _normalizeRoutePrefix(String routePrefix) {
  final trimmed = routePrefix.trim();
  if (trimmed.isEmpty || trimmed == '/') {
    return '/';
  }

  final withLeadingSlash = trimmed.startsWith('/') ? trimmed : '/$trimmed';
  if (withLeadingSlash.length > 1 && withLeadingSlash.endsWith('/')) {
    return withLeadingSlash.substring(0, withLeadingSlash.length - 1);
  }

  return withLeadingSlash;
}
