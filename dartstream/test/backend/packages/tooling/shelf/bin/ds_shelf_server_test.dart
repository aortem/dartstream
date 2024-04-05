// Import Top Level Package
import 'package:ds_shelf/ds_shelf_test.dart' as shelf; //Coverage for shelf
import 'package:ds_shelf/ds_shelf_test.dart'; //Coverage for other packages

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
