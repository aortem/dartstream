import 'dart:io';
import 'package:test/test.dart';
import 'package:ds_middleware/src/http_helpers/ds_http_helpers.dart';

void main() {
  group('DsHttpHelpers', () {
    test('ok() returns 200 response', () {
      final response = DsHttpHelpers.ok('Success');
      expect(response.statusCode, 200);
      expect(response.body, 'Success');
    });

    test('json() returns proper JSON', () {
      final response = DsHttpHelpers.jsonResponse({'user': 'Alice'});
      expect(response.statusCode, 200);
      expect(response.headers['Content-Type'], 'application/json');
      expect(response.body, '{"user":"Alice"}');
    });

    test('error() returns standardized error', () {
      final response = DsHttpHelpers.error(
        message: 'DB failed',
        statusCode: 500,
      );
      expect(response.statusCode, 500);
      expect(response.body, '{"status":500,"error":"DB failed"}');
    });

    test('withCors() adds CORS headers', () {
      final response = DsHttpHelpers.ok('Test');
      final corsResponse = DsHttpHelpers.withCors(response);
      expect(corsResponse.headers['Access-Control-Allow-Origin'], '*');
      expect(
        corsResponse.headers['Access-Control-Allow-Methods'],
        'GET, POST, PUT, DELETE',
      );
    });

    test('withCache() adds Cache-Control header', () {
      final response = DsHttpHelpers.ok('Cache Test');
      final cacheResponse = DsHttpHelpers.withCache(
        response,
        maxAgeSeconds: 600,
        isPrivate: true,
      );
      expect(cacheResponse.headers['Cache-Control'], 'private, max-age=600');
    });

    test('file() returns stream response', () async {
      final tempFile = File('temp_test.txt')..writeAsStringSync('Hello Stream');
      final response = DsHttpHelpers.file(tempFile, fileName: 'temp_test.txt');

      expect(response.statusCode, 200);
      expect(
        response.headers['Content-Disposition'],
        'attachment; filename="temp_test.txt"',
      );

      // Cast body as Stream<List<int>>
      final stream = response.body as Stream<List<int>>;

      final contents = await stream.fold<List<int>>(
        [],
        (prev, element) => prev..addAll(element),
      );
      expect(String.fromCharCodes(contents), 'Hello Stream');

      tempFile.deleteSync();
    });
  });
}
