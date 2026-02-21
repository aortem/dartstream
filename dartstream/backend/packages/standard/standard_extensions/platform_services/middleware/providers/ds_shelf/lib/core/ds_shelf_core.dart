// lib/src/core/ds_shelf_core.dart

//import 'package:ds_shelf/ds_shelf.dart' as shelf;
import '../ds_shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';

/// Core DSL for building a ds_shelf-powered server with middleware and routing.
class DSShelfCore {
  final List<shelf.Middleware> _middlewares = [];
  final Router _router = Router();
  final List<String> _registeredRoutes = [];

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
    _registeredRoutes.add('GET\t/health');
    _router.get('/health', (shelf.Request request) {
      return shelf.Response.ok('OK');
    });
  }

  /// Utility to register a GET route easily.
  void addGetRoute(String path, shelf.Handler handler) {
    _registeredRoutes.add('GET\t$path');
    _router.get(path, handler);
  }

  /// Utility to register a POST route easily.
  void addPostRoute(String path, shelf.Handler handler) {
    _registeredRoutes.add('POST\t$path');
    _router.post(path, handler);
  }

  /// Registers a static file handler.
  ///
  /// [fileSystemPath] is the directory to serve files from (e.g., 'public').
  /// [routePath] is the URL prefix to mount the handler on (defaults to '/').
  void addStaticRoute(String fileSystemPath, {String routePath = '/'}) {
    _registeredRoutes.add('STATIC\t$routePath ($fileSystemPath)');
    
    // Create the static handler using shelf_static directly
    // We assume default document is index.html for root mounts
    var staticHandler = shelf.createStaticHandler(
      fileSystemPath,
      defaultDocument: 'index.html',
    );

    // Mount the handler.
    // shelf_router's mount expects a prefix.
    _router.mount(routePath, staticHandler);
  }

  /// Registers a WebSocket route.
  /// 
  /// [path] is the URL path for the WebSocket connection.
  /// [handler] is the shelf handler that upgrades to WebSocket.
  void addWebSocketRoute(String path, shelf.Handler handler) {
    _registeredRoutes.add('WS\t$path');
    _router.all(path, handler);
  }

  /// Mounts a handler at a specific path.
  void mount(String path, shelf.Handler handler) {
    _registeredRoutes.add('MOUNT\t$path');
    _router.mount(path, handler);
  }

  /// Prints all registered routes to the console.
  void printRoutes() {
    print('╔════════════════════════════════════════════════════╗');
    print('║             Registered Routes                      ║');
    print('╠════════════════════════════════════════════════════╣');
    if (_registeredRoutes.isEmpty) {
      print('║ No routes registered.                              ║');
    } else {
      for (final route in _registeredRoutes) {
        print('║ $route'.padRight(52) + ' ║');
      }
    }
    print('╚════════════════════════════════════════════════════╝');
  }
}
