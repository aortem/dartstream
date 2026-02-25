class DsUploadedFile {
  final String fieldName;
  final String fileName;
  final String? contentType;
  final List<int> bytes;

  DsUploadedFile({
    required this.fieldName,
    required this.fileName,
    required this.bytes,
    this.contentType,
  });
}