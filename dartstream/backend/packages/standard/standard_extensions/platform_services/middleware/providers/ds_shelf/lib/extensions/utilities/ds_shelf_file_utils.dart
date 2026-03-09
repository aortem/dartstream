import 'dart:convert';
import 'dart:io';

import 'package:ds_storage_base/ds_storage_base_export.dart';
import 'package:shelf/shelf.dart';

class DSShelfUploadedFileResult {
  final String fileName;
  final String? contentType;
  final int size;
  final String destination;
  final bool cloudUploaded;

  const DSShelfUploadedFileResult({
    required this.fileName,
    required this.size,
    required this.destination,
    required this.cloudUploaded,
    this.contentType,
  });
}

Future<DSShelfUploadedFileResult> dsShelfSaveUploadedFile(
  Request request, {
  String? targetPath,
  String uploadDirectory = 'upload',
  DSStorageManager? storageManager,
  String? storagePath,
  Map<String, dynamic>? metadata,
  String fieldName = 'file',
}) async {
  final contentTypeHeader =
      request.headers['content-type'] ?? request.headers['Content-Type'];
  if (contentTypeHeader == null) {
    throw FormatException('Missing Content-Type header.');
  }

  if (!contentTypeHeader.toLowerCase().startsWith('multipart/form-data')) {
    throw FormatException('Expected multipart/form-data request.');
  }

  final boundary = _extractBoundary(contentTypeHeader);
  if (boundary == null || boundary.isEmpty) {
    throw FormatException('Missing multipart boundary.');
  }

  final bodyBytes = <int>[];
  await for (final chunk in request.read()) {
    bodyBytes.addAll(chunk);
  }
  final body = latin1.decode(bodyBytes);

  final rawParts = body.split('--$boundary');
  _MultipartFilePart? uploadedPart;
  for (final rawPart in rawParts) {
    final candidate = _MultipartFilePart.fromRawPart(rawPart);
    if (candidate == null) {
      continue;
    }
    if (!candidate.isFile) {
      continue;
    }
    final nameMatches =
        candidate.fieldName == null ||
        candidate.fieldName == fieldName ||
        fieldName.isEmpty;
    if (nameMatches) {
      uploadedPart = candidate;
      break;
    }
  }

  if (uploadedPart == null) {
    throw StateError('No uploaded file part found for field "$fieldName".');
  }

  final fileName = uploadedPart.fileName!;
  final contentType = uploadedPart.contentType;
  final bytes = uploadedPart.data;
  final effectiveMetadata = <String, dynamic>{
    if (contentType != null) 'contentType': contentType,
    ...?metadata,
  };

  if (storageManager != null) {
    final uploadPath = storagePath ?? fileName;
    final destination = await storageManager.uploadFile(
      uploadPath,
      bytes,
      metadata: effectiveMetadata,
    );
    return DSShelfUploadedFileResult(
      fileName: fileName,
      contentType: contentType,
      size: bytes.length,
      destination: destination,
      cloudUploaded: true,
    );
  }

  final resolvedPath = targetPath ?? _joinPath(uploadDirectory, fileName);
  final file = File(resolvedPath);
  final parent = file.parent;
  if (!parent.existsSync()) {
    await parent.create(recursive: true);
  }

  await file.writeAsBytes(bytes);
  return DSShelfUploadedFileResult(
    fileName: fileName,
    contentType: contentType,
    size: bytes.length,
    destination: file.path,
    cloudUploaded: false,
  );
}

String? _extractBoundary(String contentTypeHeader) {
  final match = RegExp(
    r'boundary="?([^";]+)"?',
    caseSensitive: false,
  ).firstMatch(contentTypeHeader);
  final boundary = match?.group(1)?.trim();
  if (boundary == null || boundary.isEmpty) {
    return null;
  }
  return boundary;
}

String _joinPath(String base, String name) {
  if (base.endsWith('/') || base.endsWith('\\')) {
    return '$base$name';
  }
  return '$base${Platform.pathSeparator}$name';
}

class _MultipartFilePart {
  final String? fieldName;
  final String? fileName;
  final String? contentType;
  final List<int> data;

  const _MultipartFilePart({
    required this.fieldName,
    required this.fileName,
    required this.contentType,
    required this.data,
  });

  bool get isFile => fileName != null && fileName!.isNotEmpty;

  static _MultipartFilePart? fromRawPart(String rawPart) {
    var part = rawPart.replaceAll('\r\n', '\n');
    if (part.trim().isEmpty || part.trim() == '--') {
      return null;
    }

    if (part.startsWith('\n')) {
      part = part.substring(1);
    }
    if (part.endsWith('--')) {
      part = part.substring(0, part.length - 2);
    }

    final headerSeparator = part.indexOf('\n\n');
    if (headerSeparator < 0) {
      return null;
    }

    final headerBlock = part.substring(0, headerSeparator);
    var bodyBlock = part.substring(headerSeparator + 2);
    if (bodyBlock.endsWith('\n')) {
      bodyBlock = bodyBlock.substring(0, bodyBlock.length - 1);
    }

    final headers = _parseHeaders(headerBlock);
    final disposition = headers['content-disposition'] ?? '';
    final contentTypeHeader = headers['content-type'];
    final fileName = _extractDispositionValue(disposition, 'filename');
    final fieldName = _extractDispositionValue(disposition, 'name');
    final bytes = latin1.encode(bodyBlock);

    return _MultipartFilePart(
      fieldName: fieldName,
      fileName: fileName,
      contentType: contentTypeHeader,
      data: bytes,
    );
  }

  static Map<String, String> _parseHeaders(String headerBlock) {
    final headers = <String, String>{};
    for (final line in headerBlock.split('\n')) {
      final separator = line.indexOf(':');
      if (separator < 0) {
        continue;
      }
      final key = line.substring(0, separator).trim().toLowerCase();
      final value = line.substring(separator + 1).trim();
      headers[key] = value;
    }
    return headers;
  }

  static String? _extractDispositionValue(String value, String key) {
    final pattern = RegExp('$key="([^"]*)"');
    final match = pattern.firstMatch(value);
    final extracted = match?.group(1)?.trim();
    if (extracted == null || extracted.isEmpty) {
      return null;
    }
    return extracted;
  }
}
