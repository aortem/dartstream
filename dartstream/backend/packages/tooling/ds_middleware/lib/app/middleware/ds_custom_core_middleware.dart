import 'package:http/http.dart';

class DsCustomMiddlewareRequest extends Request {
  DsCustomMiddlewareRequest(super.method, super.url);
}

class DsCustomMiddlewareResponse extends Response {
  DsCustomMiddlewareResponse(super.body, super.statusCode);
}

typedef Handler = Future<Response> Function(Request request);
typedef Middleware = Future<Response> Function(
    Request request, Handler handler);

class DsCustomMiddleware {
  final Middleware _innerMiddleware;

  DsCustomMiddleware(this._innerMiddleware);

  Future<Response> call(Request request, Handler handler) async {
    print('Before middleware: Request - ${request.url}');
    final response = await _innerMiddleware(request, handler);
    response.headers['X-Custom-Header'] = 'Added by Middleware';
    print('After middleware: Response - ${response.statusCode}');
    return response;
  }
}

Future<Response> myRequestHandler(Request request) async {
  // final response = Response(
  //   '{"name": "John", "age": 30}',
  //   200,
  // );
  final response = Response(
    'Success',
    200,
  );
  print(response.body); // Print the response body
  return response;
}

Future<Response> runMiddlewareChain(
    //   Request request, Handler handler, List<Middleware> middlewares) async {
    // Handler currentHandler = handler;

    // // Chain middlewares in reverse order
    // for (final middleware in middlewares.reversed) {
    //   currentHandler = (Request request) async {
    //     return await middleware(request, currentHandler);
    //   };
    // }

    // // Start request handling
    // return await currentHandler(request);
    Request request,
    Handler handler,
    List<Middleware> middlewares) async {
  Handler currentHandler = handler;

  // Chain middlewares in reverse order
  for (final middleware in middlewares.reversed) {
    final Handler previousHandler = currentHandler;
    currentHandler = (Request request) async {
      return await middleware(request, previousHandler);
    };
  }

  // Start request handling
  return await currentHandler(request);
}
