import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../models/ds_custom_middleware_model.dart';
import '../models/ds_uploaded_file.dart';

class DsBodyParser {
  Future<Map<String, dynamic>> parseBody(
    DsCustomMiddleWareRequest request,
  ) async {
    final contentTypeHeader = request.headers['content-type'];

    if (contentTypeHeader == null) {
      return {};
    }

    if (contentTypeHeader.contains('application/json')) {
      final body = await utf8.decoder.bind(request.read()).join();
      return jsonDecode(body) as Map<String, dynamic>;
    }

    if (contentTypeHeader.contains('application/x-www-form-urlencoded')) {
      final body = await utf8.decoder.bind(request.read()).join();
      return Uri.splitQueryString(body);
    }

    if (contentTypeHeader.contains('multipart/form-data')) {
      return await _parseMultipart(request, contentTypeHeader);
    }

    // fallback
    final body = await utf8.decoder.bind(request.read()).join();
    return {'rawBody': body};
  }

  Future<DsCustomMiddleWareResponse> handleFileUpload(
    DsCustomMiddleWareRequest request,
  ) async {
    final contentTypeHeader = request.headers['content-type'];
    if (contentTypeHeader == null ||
        !contentTypeHeader.contains('multipart/form-data')) {
      return DsCustomMiddleWareResponse.badRequest(
        'Content-Type must be multipart/form-data',
      );
    }

    final mediaType = MediaType.parse(contentTypeHeader);
    final boundary = mediaType.parameters['boundary'];
    if (boundary == null)
      return DsCustomMiddleWareResponse.badRequest('Missing boundary');

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

      final sanitizedFileName = fileName.replaceAll(
        RegExp(r'[^a-zA-Z0-9\.\-_]'),
        '_',
      );
      final fileBytes = await part.fold<Uint8List>(Uint8List(0), (
        prev,
        element,
      ) {
        final newBytes = Uint8List(prev.length + element.length);
        newBytes.setRange(0, prev.length, prev);
        newBytes.setRange(prev.length, newBytes.length, element);
        return newBytes;
      });

      final file = File('${uploadDir.path}/$sanitizedFileName');
      await file.writeAsBytes(fileBytes);

      savedFiles.add(
        DsUploadedFile(
          fieldName: fieldName ?? '',
          fileName: sanitizedFileName,
          bytes: fileBytes,
          contentType: part.headers['content-type'],
        ),
      );
    }

    return DsCustomMiddleWareResponse.ok(
      {
            'message': 'Upload successful',
            'files': savedFiles.map((f) => f.fileName).toList(),
          }
          as String,
    );
  }

  Future<Map<String, dynamic>> _parseMultipart(
    DsCustomMiddleWareRequest request,
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

      final contentType = part.headers['content-type'];

      final bytes = await part.fold<List<int>>(
        [],
        (previous, element) => previous..addAll(element),
      );

      if (fileName != null) {
        // It's a file
        files.add(
          DsUploadedFile(
            fieldName: fieldName ?? '',
            fileName: fileName,
            contentType: contentType,
            bytes: bytes,
          ),
        );
      } else if (fieldName != null) {
        // It's a normal field
        fields[fieldName] = utf8.decode(bytes);
      }
    }

    return {'fields': fields, 'files': files};
  }

  Future<DsCustomMiddleWareRequest> addParsedBodyToRequest(
    DsCustomMiddleWareRequest request,
  ) async {
    final parsedBody = await parseBody(request);
    return request.copyWith(body: parsedBody);
  }
}
