// Import Top Level Package
import 'package:ds_shelf/ds_shelf_test.dart' as shelf; //Coverage for shelf
import 'package:ds_shelf/ds_shelf_test.dart'; //Coverage for other packages

//Import other core packages
import 'dart:io';

Future<File> saveUploadedFile(shelf.Request request, String targetPath) async {
  final content = await request.readAsString();
  final file = File(targetPath);
  await file.writeAsString(content);
  return file;
}

abstract class DS extends DSUtilitiesBase {}
