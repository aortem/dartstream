// lib/src/utilities/ds_shelf_file_utils.dart
import 'dart:io';
import 'package:shelf/shelf.dart';

/// Save request body to a file at [targetPath].
Future<File> dsShelfSaveUploadedFile(Request request, String targetPath) async {
  final content = await request.readAsString();
  final file = File(targetPath);
  return file.writeAsString(content);
}
