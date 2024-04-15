import 'dart:io'; //Part Of The Dart SDK Core

// Function to parse the request path
Map<String, String> parsePath(String path) {
  final parts = path.split('/');
  final params = <String, String>{};

  // Start at index 2 to skip the first part (empty string) and the resource name
  for (var i = 1; i < parts.length; i += 2) {
    if (i + 1 < parts.length) {
      params[parts[i]] = parts[i + 1];
    }
  }
  return params;
}

// Handler function for processing requests
void handleRequest(HttpRequest request) {
  final path = request.uri.path;
  final params = parsePath(path);

  // Define logic for different routes based on path and parameters
  if (path == '/users') {
    // Handle request for all users (replace with actual logic)
    request.response.write('Fetching all users...');
  } else if (path.startsWith('/users/') && path.length > 7) {
    final userId = params['users'];
    if (userId != null) {
      // Handle request for specific user by ID (replace with actual logic)
      request.response.write('Fetching user with ID $userId...');
    } else {
      request.response.statusCode = HttpStatus.badRequest;
      request.response.write('Missing user ID parameter');
    }
  } else {
    request.response.statusCode = HttpStatus.notFound;
    request.response.write('404 Not Found');
  }

  request.response.close();
}

// Main function
/*void main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  server.listen(handleRequest);
  print('Server listening on port 8080');
} */

void usman() async (
final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  server.listen(handleRequest);
  print('Server listening on port 8080');
);