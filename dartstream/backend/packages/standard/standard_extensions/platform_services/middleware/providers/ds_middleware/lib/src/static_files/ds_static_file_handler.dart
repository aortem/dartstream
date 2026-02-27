import 'dart:io';
import 'package:mime/mime.dart';
import '../../app/models/ds_custom_middleware_model.dart';

/// Middleware/Handler for serving static files.
class DsStaticFileHandler {
  final String basePath;

  DsStaticFileHandler(this.basePath);

  /// Checks if the request URI path corresponds to a file in the base directory.
  /// Returns a [DsCustomMiddleWareResponse] if the file is found, otherwise 404.
  Future<DsCustomMiddleWareResponse> handleRequest(
    DsCustomMiddleWareRequest request,
  ) async {
    final path = request.uri.path;

    // Basic security check: prevent directory traversal
    if (path.contains('..')) {
      return DsCustomMiddleWareResponse.notFound();
    }

    // Construct a potential file path.
    // Remove leading slash from path to make it relative.
    final relativePath = path.startsWith('/') ? path.substring(1) : path;
    if (relativePath.isEmpty) return DsCustomMiddleWareResponse.notFound();

    final file = File('$basePath/$relativePath');
    if (await file.exists()) {
      return await _serveFile(file);
    }

    return DsCustomMiddleWareResponse.notFound();
  }

  Future<DsCustomMiddleWareResponse> _serveFile(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';

      return DsCustomMiddleWareResponse(200, {'content-type': mimeType}, bytes);
    } catch (e) {
      return DsCustomMiddleWareResponse(500, {}, 'Error reading file: $e');
    }
  }
}
