import 'dart:io';
import 'package:mime/mime.dart';
import '../../app/models/ds_custom_middleware_model.dart';

/// Middleware/Handler for serving static files.
class DsStaticFileHandler {
  final List<String> baseDirs;

  DsStaticFileHandler([dynamic dirs = 'public'])
    : baseDirs = dirs is List<String> ? dirs : [dirs.toString()];

  /// Checks if the request URI path corresponds to a file in one of the base directories.
  /// Returns a [DsCustomMiddleWareResponse] if the file is found, otherwise null.
  Future<DsCustomMiddleWareResponse?> handle(
    DsCustomMiddleWareRequest request,
  ) async {
    final path = request.uri.path;

    // Basic security check: prevent directory traversal
    if (path.contains('..')) {
      return null;
    }

    // Check each directory
    for (final dir in baseDirs) {
      // Construct a potential file path.
      // Remove leading slash from path to make it relative.
      final relativePath = path.startsWith('/') ? path.substring(1) : path;
      if (relativePath.isEmpty) continue;

      final file = File('$dir/$relativePath');
      if (await file.exists()) {
        return await _serveFile(file);
      }
    }

    return null;
  }

  /// Compatibility method for older usage if needed
  Future<DsCustomMiddleWareResponse> handleRequest(
    DsCustomMiddleWareRequest request,
  ) async {
    final response = await handle(request);
    return response ?? DsCustomMiddleWareResponse.notFound();
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
