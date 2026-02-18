import 'dart:convert';
import 'dart:io';

import 'package:ds_middleware/ds_custom_middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

// --- 1. Define Custom Types And Handlers ---

class User {
  final String name;
  final int age;

  User(this.name, this.age);

  Map<String, dynamic> toJson() => {'name': name, 'age': age};

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json['name'], json['age']);
  }

  @override
  String toString() => 'User(name: $name, age: $age)';
}

class UserHandler implements TypeHandler<User> {
  @override
  dynamic serialize(User value) => value.toJson();

  @override
  User deserialize(dynamic value) {
    if (value is Map<String, dynamic>) {
      return User.fromJson(value);
    }
    if (value is String) {
       return User.fromJson(jsonDecode(value));
    }
    throw FormatException('Cannot deserialize User from $value');
  }

  @override
  bool canHandle(dynamic value) => value is User;
}

// --- 2. Define Middleware/Handler Logic ---

/// A simple adapter that converts Shelf Request -> DsRequest -> Handler -> DsResponse -> Shelf Response
Future<Response> shelfAdapter(Request shelfRequest) async {
  try {
    // 1. Convert Shelf Request to DsCustomMiddleWareRequest
    // Note: We need to read body. efficient body reading depends on use case.
    // For this example, we read as String.
    final bodyString = await shelfRequest.readAsString();
    
    // Parse JSON if content-type is json, otherwise keep string
    dynamic body;
    if (shelfRequest.mimeType == 'application/json' && bodyString.isNotEmpty) {
      body = jsonDecode(bodyString);
    } else {
      body = bodyString;
    }

    final dsRequest = DsCustomMiddleWareRequest(
      shelfRequest.method,
      shelfRequest.requestedUri,
      shelfRequest.headers,
      body,
      shelfRequest.url.queryParameters,
      routeParams: {} // Route params would come from router if we had one wrapping this
    );

    // 2. Route/Handle logic
    DsCustomMiddleWareResponse dsResponse;
    
    if (dsRequest.uri.path == '/user' && dsRequest.method == 'POST') {
      // Endpoint: Receive User, Return User (modified)
      try {
        final user = dsRequest.bodyAs<User>();
        print('Received User: $user');
        
        final responseUser = User(user.name, user.age + 1); // Aging logic
        dsResponse = DsCustomMiddleWareResponse.ok(responseUser);
      } catch (e) {
        dsResponse = DsCustomMiddleWareResponse(400, {}, {'error': 'Invalid User: $e'});
      }
    } else if (dsRequest.uri.path == '/' || dsRequest.uri.path == '/index') {
      // Endpoint: Root
      dsResponse = DsCustomMiddleWareResponse.ok('''
      <html>
        <head><title>DartStream Localhost Example</title></head>
        <body style="font-family: sans-serif; padding: 20px;">
          <h1>DartStream Middleware Example</h1>
          <p>Server is running!</p>
          <ul>
            <li><a href="/time">Get Time (/time)</a> - Returns a DateTime object serialized by DateHandler.</li>
            <li><strong>POST /user</strong> - Send a JSON body {"name": "...", "age": ...} to test UserHandler.</li>
          </ul>
        </body>
      </html>
      ''');
      dsResponse.headers['content-type'] = 'text/html';
    } else if (dsRequest.uri.path == '/time' && dsRequest.method == 'GET') {
      // Endpoint: Return DateTime
      dsResponse = DsCustomMiddleWareResponse.ok(DateTime.now());
    } else {
      dsResponse = DsCustomMiddleWareResponse.notFound();
    }

    // 3. Convert DsResponse to Shelf Response
    // TypeHandlerRegistry.serialize(body) is already called in DsCustomMiddleWareResponse constructor!
    // So dsResponse.body is already serialized (e.g. Map or String).
    
    String finalBody;
    if (dsResponse.body is String) {
      finalBody = dsResponse.body;
    } else {
      finalBody = jsonEncode(dsResponse.body);
    }

    return Response(
      dsResponse.statusCode,
      headers: dsResponse.headers,
      body: finalBody,
    );
  } catch (e, stack) {
    print('Error: $e\n$stack');
    return Response.internalServerError(body: 'Internal Server Error: $e');
  }
}

void main() async {
  // Register Handlers
  TypeHandlerRegistry.register<DateTime>(DateHandler());
  TypeHandlerRegistry.register<User>(UserHandler());
  print('Handlers registered.');

  // Check dependencies
  // We need 'shelf' and 'shelf_io' which we added to dev_dependencies.

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(shelfAdapter);

  final server = await shelf_io.serve(handler, 'localhost', 8085);
  print('Server listening on http://${server.address.host}:${server.port}');
  print('Try these commands:');
  print('  curl -X GET http://localhost:8080/time');
  print('  curl -X POST -H "Content-Type: application/json" -d \'{"name": "Alice", "age": 30}\' http://localhost:8080/user');
}
