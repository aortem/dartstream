import 'dart:async';

// Define a typedef for request handler function
typedef RequestHandler = FutureOr<void> Function(CustomRequest request);

// Custom request class
class CustomRequest {
  final String method;
  final Uri uri;

  CustomRequest(this.method, this.uri);
}

// Custom middleware class
class CustomMiddleware {
  Future<void> handleRequest(
      CustomRequest request, RequestHandler handler) async {
    // Code to execute before handling the request
    print('Custom Middleware: Before handling request');

    // Pass the request to the next handler
    await handler(request);

    // Code to execute after handling the request
    print('Custom Middleware: After handling request');
  }
}

// Example usage
Future<void> main() async {
  // Simulate a request
  final request = CustomRequest('GET', Uri.parse('/'));

  // Define a handler function
  Future<void> handler(CustomRequest request) async {
    // Simulate handling the request
    print('Handling request...');
    await Future.delayed(Duration(seconds: 1));
    print('Request handled.');
  }

  // Create an instance of CustomMiddleware
  final middleware = CustomMiddleware();

  // Call the handleRequest method with the request and handler function
  await middleware.handleRequest(request, handler);
}
