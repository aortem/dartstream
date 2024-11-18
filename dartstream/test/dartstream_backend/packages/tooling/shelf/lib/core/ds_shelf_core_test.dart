// Import Top Level Package
import 'package:ds_shelf/ds_shelf_test.dart' as shelf; //Coverage for shelf
import 'package:ds_shelf/ds_shelf_test.dart'; //Coverage for other packages

//Import other core packages

class DSShelfCore {
  final List<shelf.Middleware> _middlewares = [];
  final Router _router = Router();

  // Common server configurations can be initialized here

  DSShelfCore() {
    // Initialize core middleware and configurations that every server will use
    _setupCoreMiddleware();
  }

  // A method for adding middleware to the server. This could be used by subclasses or during server setup.
  void addMiddleware(shelf.Middleware middleware) {
    _middlewares.add(middleware);
  }

  // Method to get the composed handler with all middleware and routes configured
  shelf.Handler get handler {
    final pipeline = _middlewares.fold(
      shelf.Pipeline(),
      (shelf.Pipeline pipeline, middleware) =>
          pipeline.addMiddleware(middleware),
    );

    return pipeline.addHandler(_router);
  }

  // Setup core middleware that all servers will use, such as logging requests.
  void _setupCoreMiddleware() {
    addMiddleware(shelf.logRequests());
  }

  // Method to configure common routes or utilities that every server might need
  void _configureCoreRoutes() {
    // For example, a health check endpoint
    _router.get('/health', (shelf.Request request) {
      return shelf.Response.ok('OK');
    });

    // Additional core configurations...
  }

  // Utility method to easily add routes from subclasses or during initialization
  void addRoute(String path, shelf.Handler handler) {
    _router.add('GET', path, handler);
  }
}
