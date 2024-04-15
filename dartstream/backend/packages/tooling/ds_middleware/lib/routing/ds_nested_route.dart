import 'dart:io'; //Part Of The Dart SDK Core

void main() async {
  final server = await HttpServer.bind('localhost', 8080);
  print('Server running on localhost:${server.port}');

  server.listen((HttpRequest request) {
    final path = request.uri.path;
    final segments =
        path.split('/').where((segment) => segment.isNotEmpty).toList();

    if (segments.isEmpty) {
      handleRoot(request);
    } else if (segments.length == 1) {
      switch (segments[0]) {
        case 'about':
          handleAbout(request);
          break;
        default:
          handleNotFound(request);
      }
    } else if (segments.length == 2 && segments[0] == 'about') {
      switch (segments[1]) {
        case 'route1':
          handleNestedRoute1(request);
          break;
        case 'route2':
          handleNestedRoute2(request);
          break;
        default:
          handleNotFound(request);
      }
    } else {
      handleNotFound(request);
    }
  });
}

void handleRoot(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.ok
    ..write('Welcome to the homepage!')
    ..close();
}

void handleAbout(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.ok
    ..write('This is the about page!')
    ..close();
}

void handleNestedRoute1(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.ok
    ..write('This is nested route 1!')
    ..close();
}

void handleNestedRoute2(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.ok
    ..write('This is nested route 2!')
    ..close();
}

void handleNotFound(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.notFound
    ..write('404 Not Found')
    ..close();
}


// localhost:8080/about
// localhost:8080/about/route1
// localhost:8080/about/route2