import 'dart:async';

// Define your Request and Response classes
class Request {}

class Response {
  final String body;
  Response(this.body);
}

// Define your logging middleware
class LoggingMiddleware {
  Future<void> handle(Request request, Function(Request) next) async {
    print('Logging: Request received');
    final response = await next(request);
    print('Logging: Response sent');
    return response;
  }
}

// Define Dartstream class
class Dartstream {
  final Function(Request) _handler;
  final List<LoggingMiddleware> _middlewares;

  Dartstream(this._handler, this._middlewares);

  Future<Response> handleRequest(Request request) async {
    Function(Request) pipeline = _handler;
    for (var middleware in _middlewares.reversed) {
      pipeline = (Request req) async {
        return middleware.handle(req, pipeline);
      };
    }
    return await pipeline(request);
  }
}

void main() async {
  handler(Request request) async {
    // Application logic
    return Response('Hello, Dartstream!');
  }

  final loggingMiddleware = LoggingMiddleware();
  final dartstream = Dartstream(handler, [loggingMiddleware]);

  final request = Request(); // Construct your request object
  final response = await dartstream.handleRequest(request);

  print('Response: ${response.body}');
}
