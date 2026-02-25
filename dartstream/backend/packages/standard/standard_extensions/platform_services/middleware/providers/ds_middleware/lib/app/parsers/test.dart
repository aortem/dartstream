import 'dart:convert';
import 'package:ds_tools_testing/ds_tools_testing.dart';

import 'package:ds_middleware/app/parsers/ds_body_parser.dart';
import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';
import 'package:ds_middleware/app/models/ds_uploaded_file.dart';

class FakeRequest extends DsCustomMiddleWareRequest {
  final Stream<List<int>> _stream;

  FakeRequest({
    required String method,
    required Map<String, String> headers,
    required Stream<List<int>> stream,
  })  : _stream = stream,
       super(
  method: method,
  uri: Uri.parse('http://localhost'),
  headers: headers,
  body: null,
  routeParams: {},
  queryParams: {},
);

  @override
  Stream<List<int>> read() => _stream;
}

void main() {
  group('DsBodyParser - JSON', () {
    test('parses JSON correctly', () async {
      final body = jsonEncode({'name': 'John'});

      final request = FakeRequest(
        method: 'POST',
        headers: {'content-type': 'application/json'},
        stream: Stream.value(utf8.encode(body)),
      );

      final parser = DsBodyParser();
      final result = await parser.parseBody(request);

      expect(result['name'], 'John');
    });
  });

  group('DsBodyParser - URL Encoded', () {
    test('parses form-urlencoded correctly', () async {
      final body = 'name=John&age=20';

      final request = FakeRequest(
        method: 'POST',
        headers: {'content-type': 'application/x-www-form-urlencoded'},
        stream: Stream.value(utf8.encode(body)),
      );

      final parser = DsBodyParser();
      final result = await parser.parseBody(request);

      expect(result['name'], 'John');
      expect(result['age'], '20');
    });
  });

  group('DsBodyParser - Multipart', () {
    test('parses multipart with file and field', () async {
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

      final request = FakeRequest(
        method: 'POST',
        headers: {
          'content-type': 'multipart/form-data; boundary=$boundary'
        },
        stream: Stream.value(utf8.encode(multipartBody)),
      );

      final parser = DsBodyParser();
      final result = await parser.parseBody(request);

      expect(result['fields']['name'], 'John');

      final files = result['files'] as List<DsUploadedFile>;
      expect(files.length, 1);
      expect(files.first.fileName, 'file.txt');
      expect(utf8.decode(files.first.bytes), 'hello world');
    });

    test('throws when boundary missing', () async {
      final request = FakeRequest(
        method: 'POST',
        headers: {'content-type': 'multipart/form-data'},
        stream: Stream.empty(),
      );

      final parser = DsBodyParser();

      expect(
        () async => await parser.parseBody(request),
        throwsFormatException,
      );
    });
  });
}