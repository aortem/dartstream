import 'dart:io';
import 'package:ds_shelf/ds_shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:ds_middleware/app/controllers/ds_download_handler.dart';

void main() async {
  // 1. Setup a directory for downloads
  final downloadDir = Directory('downloads_example');
  if (!downloadDir.existsSync()) {
    downloadDir.createSync();
  }
  
  // Create a dummy file
  File('${downloadDir.path}/hello.txt').writeAsStringSync('Hello from DartStream Download!');

  // 2. Create the router
  final app = Router();
  
  // Add the download route
  // Note: The handler expects the request to have a route param named 'file'
  app.get('/download/<file>', createDownloadHandler(downloadDir.path));
  
  app.get('/', (Request request) {
    return Response.ok('Visit /download/hello.txt to test downloading.');
  });

  // 3. Create the server
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(app.call);

  final server = await shelf_io.serve(handler, 'localhost', 8080);
  print('Serving at http://${server.address.host}:${server.port}');
  print('Try downloading: http://localhost:8080/download/hello.txt');
}
