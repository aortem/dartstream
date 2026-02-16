// lib/src/core/ds_shelf_core.dart

//import 'package:ds_shelf/ds_shelf.dart' as shelf;
import '../ds_shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';

/// Core DSL for building a ds_shelf-powered server with middleware and routing.
class DSShelfCore {
  final List<shelf.Middleware> _middlewares = [];
  final Router _router = Router();

  /// Initialize core middleware and server configurations.
  DSShelfCore() {
    _setupCoreMiddleware();
    _configureCoreRoutes();
  }

  /// Adds a middleware to the pipeline.
  void addMiddleware(shelf.Middleware middleware) {
    _middlewares.add(middleware);
  }

  /// Composed handler with all registered middleware and routes.
  shelf.Handler get handler {
    var pipeline = shelf.Pipeline();
    for (final mw in _middlewares) {
      pipeline = pipeline.addMiddleware(mw);
    }
    return pipeline.addHandler(_router);
  }

  /// Default core middleware (e.g. logging).
  void _setupCoreMiddleware() {
    addMiddleware(shelf.logRequests());
  }

  /// Default core routes (e.g. health-check).
  void _configureCoreRoutes() {
    _router.get('/health', (shelf.Request request) {
      return shelf.Response.ok('OK');
    });
  }

  /// Utility to register a GET route easily.
  void addGetRoute(String path, shelf.Handler handler) {
    _router.get(path, handler);
  }
}
