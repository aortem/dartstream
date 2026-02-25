import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:shelf/shelf.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../models/ds_uploaded_file.dart';

Middleware dsShelfBodyParserMiddleware() {
  return (Handler inner) {
    return (Request request) async {
      if (request.method == 'GET' ||
          request.method == 'HEAD' ||
          request.method == 'OPTIONS') {
        return inner(request);
      }

      final contentTypeHeader = request.headers['content-type'];
      if (contentTypeHeader == null) {
        return inner(request);
      }

      final contentType = contentTypeHeader.toLowerCase();

      try {
        // 🔥 HANDLE MULTIPART FIRST
        if (contentType.contains('multipart/form-data')) {
          final parsedBody =
              await _parseMultipart(request, contentTypeHeader);

          return inner(request.change(
            context: {
              ...request.context,
              'ds_shelf.body': parsedBody,
            },
          ));
        }

        // JSON
        if (contentType.contains('application/json')) {
          final content = await request.readAsString();
          if (content.isEmpty) return inner(request);

          final decoded = jsonDecode(content);

          return inner(request.change(
            body: content,
            context: {
              ...request.context,
              'ds_shelf.body': decoded,
            },
          ));
        }

        // URL encoded
        if (contentType.contains('application/x-www-form-urlencoded')) {
          final content = await request.readAsString();
          if (content.isEmpty) return inner(request);

          final decoded = Uri.splitQueryString(content);

          return inner(request.change(
            body: content,
            context: {
              ...request.context,
              'ds_shelf.body': decoded,
            },
          ));
        }

        // Plain text
        if (contentType.contains('text/plain')) {
          final content = await request.readAsString();

          return inner(request.change(
            body: content,
            context: {
              ...request.context,
              'ds_shelf.body': content,
            },
          ));
        }
      } catch (_) {
        return Response.badRequest(body: 'Invalid request body');
      }

      return inner(request);
    };
  };
}

Handler dsShelfFileUploadHandler() {
  return (Request request) async {
    final contentTypeHeader = request.headers['content-type'];
    if (contentTypeHeader == null || !contentTypeHeader.contains('multipart/form-data')) {
      return Response(400, body: 'Content-Type must be multipart/form-data');
    }

    final mediaType = MediaType.parse(contentTypeHeader);
    final boundary = mediaType.parameters['boundary'];
    if (boundary == null) return Response(400, body: 'Missing boundary');

    final transformer = MimeMultipartTransformer(boundary);
    final parts = request.read().transform(transformer);

    final uploadDir = Directory('./uploads');
    if (!uploadDir.existsSync()) await uploadDir.create();

    final List<DsUploadedFile> savedFiles = [];
    await for (final part in parts) {
      final contentDisposition = part.headers['content-disposition'];
      if (contentDisposition == null) continue;

      final disposition = HeaderValue.parse(contentDisposition);
      final fieldName = disposition.parameters['name'];
      final fileName = disposition.parameters['filename'];
      if (fileName == null) continue;

      final sanitizedFileName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9\.\-_]'), '_');
      final fileBytes = await part.fold<Uint8List>(
        Uint8List(0),
        (prev, element) {
          final newBytes = Uint8List(prev.length + element.length);
          newBytes.setRange(0, prev.length, prev);
          newBytes.setRange(prev.length, newBytes.length, element);
          return newBytes;
        },
      );

      final file = File('${uploadDir.path}/$sanitizedFileName');
      await file.writeAsBytes(fileBytes);

      savedFiles.add(DsUploadedFile(
        fieldName: fieldName ?? '',
        fileName: sanitizedFileName,
        bytes: fileBytes,
        contentType: part.headers['content-type'],
      ));
    }

    return Response.ok(jsonEncode({
      'message': 'Upload successful',
      'files': savedFiles.map((f) => f.fileName).toList(),
    }), headers: {'content-type': 'application/json'});
  };
}

Future<Map<String, dynamic>> _parseMultipart(
  Request request,
  String contentTypeHeader,
) async {
  final mediaType = MediaType.parse(contentTypeHeader);
  final boundary = mediaType.parameters['boundary'];

  if (boundary == null) {
    throw FormatException('Missing multipart boundary.');
  }

  final transformer = MimeMultipartTransformer(boundary);
  final parts = request.read().transform(transformer);

  final Map<String, String> fields = {};
  final List<DsUploadedFile> files = [];

  await for (final part in parts) {
    final contentDisposition = part.headers['content-disposition'];
    if (contentDisposition == null) continue;

    final disposition = HeaderValue.parse(contentDisposition);
    final fieldName = disposition.parameters['name'];
    final fileName = disposition.parameters['filename'];
    final partContentType = part.headers['content-type'];

    final bytes = await part.fold<Uint8List>(
      Uint8List(0),
      (previous, element) {
        final combined =
            Uint8List(previous.length + element.length);
        combined.setRange(0, previous.length, previous);
        combined.setRange(previous.length, combined.length, element);
        return combined;
      },
    );

    if (fileName != null) {
      files.add(DsUploadedFile(
        fieldName: fieldName ?? '',
        fileName: fileName,
        contentType: partContentType,
        bytes: bytes,
      ));
    } else if (fieldName != null) {
      fields[fieldName] = utf8.decode(bytes);
    }
  }

  return {
    'fields': fields,
    'files': files,
  };
}