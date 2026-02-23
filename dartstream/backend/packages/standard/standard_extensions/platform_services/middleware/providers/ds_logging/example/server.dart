import 'dart:io';
import 'package:ds_shelf/ds_shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:ds_logging/ds_logging.dart';

void main() async {
  // 1. Initialize our standardized logger
  final logger = DSLogger('BackendServer');
  
  // Set default level to INFO
  logger.level = LogLevel.info;
  
  logger.info('🚀 Initializing DartStream Logging Demo Server...');

  final server = DSShelfCore();

  // 2. Custom Middleware for Logging Requests
  server.addMiddleware((Handler innerHandler) {
    return (Request request) async {
      logger.debug('Incoming request: ${request.method} ${request.requestedUri.path}');
      
      final response = await innerHandler(request);
      
      if (response.statusCode >= 400) {
        logger.warning('Request failed: ${request.requestedUri.path} -> ${response.statusCode}');
      } else {
        logger.info('Request processed: ${request.requestedUri.path} -> ${response.statusCode}');
      }
      
      return response;
    };
  });

  // 3. Define Routes demonstrating levels
  server.addGetRoute('/hello', (Request request) {
    logger.debug('Entering hello route handler');
    return Response.ok('Hello! Check the terminal for logs.');
  });

  server.addGetRoute('/error', (Request request) {
    logger.error('A simulated server error occurred!');
    return Response.internalServerError(body: 'Error logged.');
  });

  server.addGetRoute('/level-debug', (Request request) {
    logger.level = LogLevel.debug;
    logger.info('Log level changed to DEBUG');
    return Response.ok('Log level set to DEBUG. Check terminal for more details.');
  });

  server.addGetRoute('/level-info', (Request request) {
    logger.level = LogLevel.info;
    logger.info('Log level changed back to INFO');
    return Response.ok('Log level set to INFO.');
  });

  // 4. Register Static Files
  String? staticPath;
  if (Directory('example/public').existsSync()) {
    staticPath = 'example/public';
  } else if (Directory('public').existsSync()) {
    staticPath = 'public';
  }

  if (staticPath != null) {
    server.addStaticRoute(staticPath);
    logger.info('📁 Static files served from: $staticPath');
    
    // Redirect root to index.html
    server.addGetRoute('/', (Request request) {
      return Response.seeOther('/index.html');
    });
  }

  // 5. Start Server
  final handler = server.handler;
  final port = 8081;
  await shelf_io.serve(handler, InternetAddress.loopbackIPv4, port);

  logger.critical('🔥 Server live at http://localhost:$port');
  logger.info('💡 Visit http://localhost:$port to see the dashboard');
}
