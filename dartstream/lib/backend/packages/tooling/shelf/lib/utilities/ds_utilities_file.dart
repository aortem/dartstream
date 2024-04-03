// Always Import the Utilities Base Class

import 'ds_utilities_base.dart';

//Import Other Packages

import 'dart:io';

Future<File> saveUploadedFile(shelf.Request request, String targetPath) async {
  final content = await request.readAsString();
  final file = File(targetPath);
  await file.writeAsString(content);
  return file;
}
