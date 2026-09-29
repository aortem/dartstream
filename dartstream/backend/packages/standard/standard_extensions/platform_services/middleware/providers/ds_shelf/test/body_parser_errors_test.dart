import 'package:ds_tools_testing/ds_tools_testing.dart';
import '../lib/ds_shelf.dart';

void main() {
  Request request(String body) => Request(
    'POST',
    Uri.parse('http://localhost/'),
    headers: {'content-type': 'application/json'},
    body: body,
  );

  test('malformed JSON returns 400 without calling the handler', () async {
    final handler = dsShelfBodyParserMiddleware()((_) {
      fail('Invalid JSON must not reach the application');
    });
    expect((await handler(request('{'))).statusCode, 400);
  });

  test('JSON null remains a valid request body', () async {
    final handler = dsShelfBodyParserMiddleware()((r) {
      expect(r.context['ds_shelf.body'], isNull);
      return Response.ok('ok');
    });
    expect((await handler(request('null'))).statusCode, 200);
  });

  for (final asynchronous in [false, true]) {
    test('handler errors propagate (asynchronous: $asynchronous)', () async {
      final error = StateError('application failure');
      final Handler inner = asynchronous
          ? (_) async => throw error
          : (_) => throw error;
      final handler = dsShelfBodyParserMiddleware()(inner);
      await expectLater(handler(request('{}')), throwsA(same(error)));
    });
  }
}
