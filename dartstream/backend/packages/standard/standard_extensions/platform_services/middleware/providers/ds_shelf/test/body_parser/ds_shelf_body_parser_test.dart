import 'dart:convert';
import 'dart:typed_data';

import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:shelf/shelf.dart';

import 'package:ds_shelf/extensions/body_parser/ds_shelf_body_parser.dart';
import 'package:ds_shelf/models/ds_uploaded_file.dart';

void main() {
  group('dsShelfBodyParserMiddleware', () {
    late Handler handler;

    setUp(() {
      handler = const Pipeline()
          .addMiddleware(dsShelfBodyParserMiddleware())
          .addHandler((request) {
        return Response.ok(
          jsonEncode(request.context['ds_shelf.body']),
          headers: {'content-type': 'application/json'},
        );
      });
    });

    test('parses JSON body correctly', () async {
      final request = Request(
  'POST',
  Uri.parse('http://localhost/'),
  headers: {'content-type': 'application/json'},
  body: '{"name":"John"}',
);

      final response = await handler(request);

      expect(response.statusCode, 200);

      final responseBody =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;

      expect(responseBody['name'], 'John');
    });

    test('parses urlencoded body correctly', () async {
      final request = Request(
  'POST',
  Uri.parse('http://localhost/'),
  headers: {'content-type': 'application/x-www-form-urlencoded'},
  body: 'name=John&age=25',
);

      final response = await handler(request);

      final responseBody =
          jsonDecode(await response.readAsString()) as Map<String, dynamic>;

      expect(responseBody['name'], 'John');
      expect(responseBody['age'], '25');
    });

    test('parses multipart form-data with file and field', () async {
  const boundary = 'test-boundary';

  final multipartBody =
      '--$boundary\r\n'
      'Content-Disposition: form-data; name="name"\r\n'
      '\r\n'
      'John\r\n'
      '--$boundary\r\n'
      'Content-Disposition: form-data; name="file"; filename="file.txt"\r\n'
      'Content-Type: text/plain\r\n'
      '\r\n'
      'hello world\r\n'
      '--$boundary--\r\n';

  final middleware = dsShelfBodyParserMiddleware();

  final handler = middleware((request) async {
    final parsed = request.context['ds_shelf.body'] as Map<String, dynamic>;

    expect(parsed['fields']['name'], 'John');

    final files = parsed['files'] as List<DsUploadedFile>;
    expect(files.length, 1);
    expect(files.first.fileName, 'file.txt');
    expect(utf8.decode(files.first.bytes), 'hello world');

    return Response.ok('success');
  });

  final request = Request(
    'POST',
    Uri.parse('http://localhost/'),
    headers: {
      'content-type': 'multipart/form-data; boundary=$boundary'
    },
    body: multipartBody,
  );

  final response = await handler(request);

  expect(response.statusCode, 200);
});

    test('returns 400 for invalid multipart boundary', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost/'),
        headers: {'content-type': 'multipart/form-data'},
        body: '',
      );

      final response = await handler(request);

      expect(response.statusCode, 400);
    });
  });
}