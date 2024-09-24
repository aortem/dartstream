import 'dart:io';
import 'package:path/path.dart' as path;
import '../model/ds_request_model.dart';
import '../model/ds_response_model.dart';

class DsStaticFileHandler {
  final String basePath;

  DsStaticFileHandler(this.basePath);

  Future<DsCustomMiddleWareResponse> handleRequest(
      DsCustomMiddleWareRequest request) async {
    final filePath = path.join(basePath, request.uri.path.substring(1));
    final file = File(filePath);

    if (await file.exists()) {
      final content = await file.readAsBytes();
      final mimeType = _getMimeType(filePath);
      return DsCustomMiddleWareResponse(
        200,
        {'Content-Type': mimeType},
        content,
      );
    } else {
      return DsCustomMiddleWareResponse.notFound();
    }
  }

  String _getMimeType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    switch (extension) {
      case '.html':
        return 'text/html';
      case '.css':
        return 'text/css';
      case '.js':
        return 'application/javascript';
      case '.png':
        return 'image/png';
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      default:
        return 'application/octet-stream';
    }
  }
}
