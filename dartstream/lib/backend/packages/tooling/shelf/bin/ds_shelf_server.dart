import 'package:ds_shelf/ds_shelf.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';
import 'package:ds_shelf/utilities/ds_utilities.dart'; // Assuming utilities are needed

// Import other necessary utilities or configurations

class DSShelfServer extends DSShelfCore {
  // List of middlewares to apply to the server.
  final List<shelf.Middleware> _middlewares = [];

  // Initial setup for router or any server-level configurations
  Router _router = Router();

  // Method to add middleware
  void addMiddleware(shelf.Middleware middleware) {
    _middlewares.add(middleware);
  }

  // Initialize and configure the server with default or added middleware
  shelf.Handler initializeServer() {
    // Apply all added middleware to the pipeline
    var pipeline = shelf.Pipeline();
    for (var middleware in _middlewares) {
      pipeline = pipeline.addMiddleware(middleware);
    }

    // Default middleware could be added here as well

    // Configure router with routes
    _configureRoutes(_router);

    // Combine middleware and router
    return pipeline.addHandler(_router);
  }

  // Example route configuration
  void _configureRoutes(Router router) {
    router.get('/', (shelf.Request request) {
      return shelf.Response.ok('Hello, DS Shelf!');
    });

    // More route configurations
  }
}
