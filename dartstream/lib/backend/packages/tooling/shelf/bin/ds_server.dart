// File: bin/ds_server.dart

import 'package:ds_shelf/ds_shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

void main(List<String> args) {
  var handler = DSCore().handler;

  // Configure and start the server
  io.serve(handler, 'localhost', 8080).then((server) {
    print('Serving at http://${server.address.host}:${server.port}');
  });
}
