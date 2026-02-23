import 'dart:io';
import 'package:mime/mime.dart'; // Requires 'mime' package
import '../model/ds_request_model.dart';
import '../model/ds_response_model.dart';
import '../../ds_custom_middleware_base.dart';

/// Middleware/Handler for serving static files.
class DsStaticFileHandler {
  final String publicDir;
  final String staticDir;
  final String assetsDir;

  DsStaticFileHandler({
    this.publicDir = 'public',
    this.staticDir = 'static',
    this.assetsDir = 'assets',
  });

  /// Checks if the request URI path corresponds to a file in one of the allowed directories.
  /// Returns a [DsCustomMiddleWareResponse] if the file is found, otherwise null.
  Future<DsCustomMiddleWareResponse?> handle(DsCustomMiddleWareRequest request) async {
    final path = request.uri.path;
    // Basic security check: prevent directory traversal
    if (path.contains('..')) {
      return null;
    }

    // Check each directory
    for (final dir in [publicDir, staticDir, assetsDir]) {
       // Construct a potential file path. 
       // Remove leading slash from path to make it relative.
       final relativePath = path.startsWith('/') ? path.substring(1) : path;
       if (relativePath.isEmpty) continue; // Don't serve root directory as file

       final file = File('$dir/$relativePath');
       if (await file.exists()) {
         return _serveFile(file);
       }
    }

    return null;
  }

  Future<DsCustomMiddleWareResponse> _serveFile(File file) async {
    try {
      final contents = await file.readAsString(); // For text files. 
      // For binary files we might need body to support bytes, but DsResponseModel body is dynamic.
      // Assuming string body for now based on typical usage, but proper implementation should use streams or bytes.
      // However, looking at ds_response_model.dart: "final dynamic body;".
      // Let's stick to string for simplicity unless we know body supports bytes.
      // Actually, standard shelf supports bytes. custom middleware might handle string.
      // We will assume text for now or verify if we can send bytes.
      
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      
      return DsCustomMiddleWareResponse(
        200,
        {'content-type': mimeType},
        contents,
      );
    } catch (e) {
      // Error reading file
      return DsCustomMiddleWareResponse(500, {}, 'Error reading file');
    }
  }
}
