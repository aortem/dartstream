import 'dart:typed_data';

class DsUploadedFile {
  final String fieldName;
  final String fileName;
  final String? contentType;
  final Uint8List bytes;

  DsUploadedFile({
    required this.fieldName,
    required this.fileName,
    required this.bytes,
    this.contentType,
  });
}