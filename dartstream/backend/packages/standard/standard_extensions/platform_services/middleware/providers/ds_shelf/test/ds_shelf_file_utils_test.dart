import 'dart:convert';
import 'dart:io';

import 'package:ds_storage_base/ds_storage_base_export.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:shelf/shelf.dart';

import '../lib/extensions/utilities/ds_shelf_file_utils.dart';

void main() {
  test(
    'dsShelfSaveUploadedFile saves multipart upload to local file',
    () async {
      final tempDir = await Directory.systemTemp.createTemp('ds_shelf_upload_');
      try {
        final request = _multipartRequest(
          boundary: 'boundary_local',
          filename: 'local.txt',
          data: 'hello local',
        );

        final targetPath = '${tempDir.path}${Platform.pathSeparator}local.txt';
        final result = await dsShelfSaveUploadedFile(
          request,
          targetPath: targetPath,
        );

        expect(result.cloudUploaded, isFalse);
        expect(result.fileName, 'local.txt');
        expect(result.size, utf8.encode('hello local').length);
        expect(File(targetPath).existsSync(), isTrue);
        expect(await File(targetPath).readAsString(), 'hello local');
      } finally {
        if (tempDir.existsSync()) {
          await tempDir.delete(recursive: true);
        }
      }
    },
  );

  test(
    'dsShelfSaveUploadedFile uploads multipart file using storage manager',
    () async {
      final providerName = 'mock_${DateTime.now().millisecondsSinceEpoch}';
      final provider = _FakeStorageProvider();

      DSStorageManager.registerProvider(
        providerName,
        provider,
        DSStorageProviderMetadata(type: 'mock'),
      );

      final manager = DSStorageManager(providerName);
      await manager.initialize({});

      final request = _multipartRequest(
        boundary: 'boundary_cloud',
        filename: 'cloud.txt',
        data: 'hello cloud',
        contentType: 'text/plain',
      );

      final result = await dsShelfSaveUploadedFile(
        request,
        storageManager: manager,
        storagePath: 'uploads/cloud.txt',
      );

      expect(result.cloudUploaded, isTrue);
      expect(result.destination, 'mock://uploads/cloud.txt');
      expect(result.fileName, 'cloud.txt');
      expect(provider.lastPath, 'uploads/cloud.txt');
      expect(utf8.decode(provider.lastData!), 'hello cloud');
      expect(provider.lastMetadata?['contentType'], 'text/plain');
    },
  );
}

Request _multipartRequest({
  required String boundary,
  required String filename,
  required String data,
  String contentType = 'text/plain',
}) {
  final body = StringBuffer()
    ..writeln('--$boundary')
    ..writeln(
      'content-disposition: form-data; name="file"; filename="$filename"',
    )
    ..writeln('content-type: $contentType')
    ..writeln()
    ..write(data)
    ..writeln()
    ..write('--$boundary--')
    ..writeln();

  return Request(
    'POST',
    Uri.parse('http://localhost/upload'),
    headers: {'content-type': 'multipart/form-data; boundary=$boundary'},
    body: utf8.encode(body.toString()),
  );
}

class _FakeStorageProvider implements DSStorageProvider {
  String? lastPath;
  List<int>? lastData;
  Map<String, dynamic>? lastMetadata;

  @override
  Future<void> initialize(Map<String, dynamic> config) async {}

  @override
  Future<String> uploadFile(
    String path,
    List<int> data, {
    Map<String, dynamic>? metadata,
  }) async {
    lastPath = path;
    lastData = data;
    lastMetadata = metadata;
    return 'mock://$path';
  }

  @override
  Future<List<int>> downloadFile(String path) async => <int>[];

  @override
  Future<void> deleteFile(String path) async {}

  @override
  Future<List<String>> listFiles(String path, {bool recursive = false}) async =>
      <String>[];

  @override
  Future<String> getSignedUrl(String path, {Duration? expiry}) async =>
      'mock://signed/$path';

  @override
  Future<void> dispose() async {}
}
