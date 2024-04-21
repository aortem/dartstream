// import 'dart:async';
/* We do not need this async library 
because it is already available in the below package.
*/

// Import Top Level Package
import 'package:ds_standard_features/ds_standard_features.dart'; //Standard Feature Set

//Import other core packages

// class DSShelfCore {
//   final List<shelf.Middleware> _middlewares = [];
//   final Router _router = Router();
// }

// Define your Request and Response classes here
class DsCustomMiddlewareRequest {}

class DsCustomMiddlewareResponse {}

typedef Handler = Future<Response> Function(Request request);
typedef Middleware = Future<Response> Function(
    Request request, Handler handler);

class DsCustomMiddleware {
  final Middleware _innerMiddleware;

  DsCustomMiddleware(this._innerMiddleware);

  Future<Response> call(Request request, Handler handler) async {
    // Do something before passing control to the inner handler
    print('Before middleware');

    final response = await _innerMiddleware(request, handler);

    // Do something after the inner handler is called
    print('After middleware');

    return response;
  }
}

Future<Response> myRequestHandler(Request request) async {
  // Your application logic goes here
  return Response(
    '{"name": "John", "age": 30}',
    200,
  );
}

Future<void> main(List<String> args) async {
  // Initialize your middleware
  final dsCustomMiddleware1 =
      DsCustomMiddleware((Request request, Handler handler) async {
    // Middleware logic goes here
    return await handler(request);
  });

  final dsCustomMiddleware2 =
      DsCustomMiddleware((Request request, Handler handler) async {
    // Another middleware logic goes here
    return await handler(request);
  });

  // Create middleware chain
  handler(Request request) async {
    // Your request handling logic
    return myRequestHandler(request);
  }

  final middlewareChain = <Middleware>[
    (Request request, Handler handler) async {
      return await dsCustomMiddleware1.call(request, handler);
    },
    (Request request, Handler handler) async {
      return await dsCustomMiddleware2.call(request, handler);
    },
  ];

  // Pass request through middleware chain
  final response = await _runMiddlewareChain(
      Request('helooo', Uri.parse("https://google.com")),
      handler,
      middlewareChain);

  // Handle response
  print(response);
}

Future<Response> _runMiddlewareChain(
    Request request, Handler handler, List<Middleware> middlewares) async {
  Handler currentHandler = handler;

  // Chain middlewares in reverse order
  for (final middleware in middlewares.reversed) {
    currentHandler = (Request request) async {
      return await middleware(request, currentHandler);
    };
  }

  // Start request handling
  return await currentHandler(request);
}
