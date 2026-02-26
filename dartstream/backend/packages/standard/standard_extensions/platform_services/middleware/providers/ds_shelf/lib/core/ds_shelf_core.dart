// lib/src/core/ds_shelf_core.dart
import 'dart:io';

import '../ds_shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';

typedef DSFileRouteHandlerFactory =
    shelf.Handler Function(File file, String routePath, String method);

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

  /// Registers routes discovered from files in [routesDirectory].
  ///
  /// File-name conventions:
  /// - `index.dart` maps to the directory root.
  /// - `[id].dart` maps to `/<id>`.
  /// - Optional method suffix: `name.get.dart`, `name.post.dart`, etc.
  ///
  /// Route handlers are provided by [handlerFactory], keeping this feature
  /// optional and additive to explicit route registration.
  void addFileBasedRoutes(
    String routesDirectory, {
    String baseRoute = '/',
    bool recursive = true,
    required DSFileRouteHandlerFactory handlerFactory,
  }) {
    final dir = Directory(routesDirectory);
    if (!dir.existsSync()) {
      throw ArgumentError.value(
        routesDirectory,
        'routesDirectory',
        'Directory does not exist.',
      );
    }

    final discoveredFiles = dir
        .listSync(recursive: recursive)
        .whereType<File>()
        .where((file) => file.path.toLowerCase().endsWith('.dart'))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));

    for (final file in discoveredFiles) {
      final parsed = _parseFileBasedRoute(
        rootDirectoryPath: dir.path,
        filePath: file.path,
        baseRoute: baseRoute,
      );

      final routePath = parsed.$1;
      final method = parsed.$2;
      final isIndexRoute = parsed.$3;
      final handler = handlerFactory(file, routePath, method);
      _registerDiscoveredRoute(method, routePath, handler);
      if (isIndexRoute && routePath != '/') {
        _registerDiscoveredRoute(method, '$routePath/', handler);
      }

      final relativePath = file.path.substring(dir.path.length).replaceAll(
            RegExp(r'^[\\/]+'),
            '',
          );
      _registeredRoutes.add('$method\t$routePath ($relativePath)');
    }
  }

  /// Registers a static file handler.
  ///
  /// [fileSystemPath] is the directory to serve files from (e.g., 'public').
  /// [routePath] is the URL prefix to mount the handler on (defaults to '/').
  void addStaticRoute(String fileSystemPath, {String routePath = '/'}) {
    _registeredRoutes.add('STATIC\t$routePath ($fileSystemPath)');

    final staticHandler = shelf.createStaticHandler(
      fileSystemPath,
      defaultDocument: 'index.html',
    );

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
    print('====================================================');
    print('             Registered Routes');
    print('====================================================');
    if (_registeredRoutes.isEmpty) {
      print('No routes registered.');
    } else {
      for (final route in _registeredRoutes) {
        print(route);
      }
    }
    print('====================================================');
  }

  (String, String, bool) _parseFileBasedRoute({
    required String rootDirectoryPath,
    required String filePath,
    required String baseRoute,
  }) {
    final relative = filePath
        .substring(rootDirectoryPath.length)
        .replaceAll(RegExp(r'^[\\/]+'), '');
    final segments = relative.split(RegExp(r'[\\/]'));
    final fileName = segments.removeLast();
    final stem = fileName.substring(0, fileName.length - '.dart'.length);
    final methodParsed = _extractMethod(stem);
    final routeStem = methodParsed.$1;
    final method = methodParsed.$2;

    final isIndexRoute = routeStem == 'index';
    if (!isIndexRoute) {
      segments.add(routeStem);
    }

    final transformedSegments =
        segments.where((s) => s.isNotEmpty).map(_toRouteSegment).toList();
    final route = _joinRoute(baseRoute, transformedSegments);
    return (route, method, isIndexRoute);
  }

  (String, String) _extractMethod(String stem) {
    final parts = stem.split('.');
    if (parts.length <= 1) {
      return (stem, 'GET');
    }

    final last = parts.last.toUpperCase();
    switch (last) {
      case 'GET':
      case 'POST':
      case 'PUT':
      case 'PATCH':
      case 'DELETE':
      case 'ALL':
        return (parts.sublist(0, parts.length - 1).join('.'), last);
      default:
        return (stem, 'GET');
    }
  }

  String _toRouteSegment(String segment) {
    if (segment.startsWith('[') && segment.endsWith(']')) {
      final inner = segment.substring(1, segment.length - 1);
      if (inner.startsWith('...') && inner.length > 3) {
        final catchAll = inner.substring(3);
        return '<$catchAll|.*>';
      }
      if (inner.isNotEmpty) {
        return '<$inner>';
      }
    }
    return segment;
  }

  String _joinRoute(String baseRoute, List<String> discoveredSegments) {
    final normalizedBase = _normalizeRoute(baseRoute);
    if (discoveredSegments.isEmpty) {
      return normalizedBase;
    }

    final suffix = discoveredSegments.join('/');
    if (normalizedBase == '/') {
      return '/$suffix';
    }
    return '$normalizedBase/$suffix';
  }

  String _normalizeRoute(String route) {
    if (route.isEmpty) {
      return '/';
    }

    var normalized = route.startsWith('/') ? route : '/$route';
    while (normalized.length > 1 && normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }

  void _registerDiscoveredRoute(
    String method,
    String path,
    shelf.Handler handler,
  ) {
    switch (method) {
      case 'GET':
        _router.get(path, handler);
        return;
      case 'POST':
        _router.post(path, handler);
        return;
      case 'PUT':
        _router.put(path, handler);
        return;
      case 'PATCH':
        _router.patch(path, handler);
        return;
      case 'DELETE':
        _router.delete(path, handler);
        return;
      case 'ALL':
        _router.all(path, handler);
        return;
      default:
        _router.get(path, handler);
    }
  }
}
