import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:mime/mime.dart';
import 'package:ds_shelf/ds_shelf.dart';

/// Creates a Shelf handler that serves files from [baseDir].
///
/// The handler expects a route parameter `file` containing the filename to download.
/// The handler expects a route parameter `file` containing the filename to download.
Handler createDownloadHandler(String baseDir) {
  return (Request request) async {
    final filename = request.params['file'];

    if (filename == null || filename.isEmpty) {
      return Response.badRequest(body: 'Filename is required');
    }

    // Security: Prevent path traversal
    final filePath = p.normalize(p.join(baseDir, filename));
    final file = File(filePath);

    if (!await file.exists()) {
      return Response.notFound('File not found');
    }

    // 1. Resolve the full path
    final resolvedPath = file.resolveSymbolicLinksSync();
    final resolvedBaseDir = Directory(baseDir).resolveSymbolicLinksSync();

    // 2. Check if the resolved path is within the base directory
    if (!p.isWithin(resolvedBaseDir, resolvedPath)) {
      return Response.forbidden('Access denied');
    }

    final mimeType = lookupMimeType(resolvedPath) ?? 'application/octet-stream';
    final fileStream = file.openRead();

    return Response.ok(
      fileStream,
      headers: {
        'Content-Type': mimeType,
        'Content-Disposition':
            'attachment; filename="${p.basename(resolvedPath)}"',
      },
    );
  };
}
