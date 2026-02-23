import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:ds_middleware/ds_custom_middleware.dart';
import 'package:ds_middleware/app/controllers/ds_download_handler.dart';
import 'package:ds_shelf/ds_shelf.dart'; // Replaces direct shelf imports
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:ds_error_handling/ds_error_handling.dart';

// --- 1. Custom Models ---

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

// --- 2. Request Handling Logic ---

final staticFileHandler = DsStaticFileHandler(publicDir: path.join(Directory.current.path, 'example', 'web'));
final corsMiddleware = DsCorsMiddleware();

/// Adapter to bridge Shelf and DartStream Middleware
Future<Response> shelfAdapter(Request shelfRequest) async {
  try {
    final bodyString = await shelfRequest.readAsString();
    
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
      routeParams: {}
    );

    if (dsRequest.method == 'OPTIONS') {
       final corsResponse = await corsMiddleware.handle(dsRequest, (req) async => DsCustomMiddleWareResponse.ok(''));
       return Response(corsResponse.statusCode, headers: corsResponse.headers, body: '');
    }

    DsCustomMiddleWareResponse dsResponse;
    
    if (dsRequest.uri.path == '/user' && dsRequest.method == 'POST') {
      try {
        final user = dsRequest.bodyAs<User>();
        print('Received User: $user');
        final responseUser = User(user.name, user.age + 1);
        dsResponse = DsCustomMiddleWareResponse.ok(responseUser);
      } catch (e) {
        dsResponse = DsCustomMiddleWareResponse(400, {}, {'error': 'Invalid User: $e'});
      }
    } else if (dsRequest.uri.path == '/time' && dsRequest.method == 'GET') {
      dsResponse = DsCustomMiddleWareResponse.ok(DateTime.now());
    } else if (dsRequest.uri.path == '/' || dsRequest.uri.path == '/index.html' || dsRequest.uri.path.startsWith('/assets/') || dsRequest.uri.path.endsWith('.css') || dsRequest.uri.path.endsWith('.js')) {
       var effectiveRequest = dsRequest;
       if (dsRequest.uri.path == '/') {
          effectiveRequest = dsRequest.copyWith(
            uri: dsRequest.uri.replace(path: '/index.html')
          );
       }
       // Serve static files
       dsResponse = (await staticFileHandler.handle(effectiveRequest)) ?? DsCustomMiddleWareResponse.notFound();
    } else {
      dsResponse = DsCustomMiddleWareResponse.notFound();
    }

    dsResponse = await corsMiddleware.handle(dsRequest, (req) async => dsResponse);

    dynamic finalBody;
    if (dsResponse.body is String || dsResponse.body is List<int>) {
      finalBody = dsResponse.body;
    } else if (dsResponse.body == null) {
      finalBody = '';
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
    rethrow;
  }
}

void main() async {
  // 1. Setup Download Directory
  final downloadDir = Directory('downloads_example');
  if (!downloadDir.existsSync()) {
    downloadDir.createSync();
  }
  File('${downloadDir.path}/hello.txt').writeAsStringSync('Hello from DartStream Download!');

  // 2. Register Custom Handlers
  TypeHandlerRegistry.register<DateTime>(DateHandler());
  TypeHandlerRegistry.register<User>(UserHandler());
  print('Custom type handlers registered.');

  // 3. Setup Router
  final router = Router();
  
  // Register download route
  router.get('/download/<file>', createDownloadHandler(downloadDir.path));

  // Forward everything else to existing adapter
  // We use mount with a root prefix to capture everything else
  router.mount('/', shelfAdapter);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(dsErrorMiddleware())
      .addHandler(router.call);

  final server = await shelf_io.serve(handler, 'localhost', 8080);
  print('Premium Sample Server listening on http://${server.address.host}:${server.port}');
  print('Try downloading: http://localhost:8080/download/hello.txt');
}
