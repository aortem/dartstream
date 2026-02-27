import 'dart:convert';
import 'package:ds_tools_testing/ds_tools_testing.dart';
import '../lib/ds_shelf.dart';

void main() {
  group('dsShelfBodyParserMiddleware', () {
    test('passes through requests without body parser if content-type is missing', () async {
      final handler = const Pipeline()
          .addMiddleware(dsShelfBodyParserMiddleware())
          .addHandler((request) {
        expect(request.context['ds_shelf.body'], isNull);
        return Response.ok('ok');
      });

      final response = await handler(Request('GET', Uri.parse('http://localhost/')));
      expect(response.statusCode, 200);
    });

    test('parses application/json', () async {
      final handler = const Pipeline()
          .addMiddleware(dsShelfBodyParserMiddleware())
          .addHandler((request) {
        expect(request.context['ds_shelf.body'], equals({'foo': 'bar'}));
        return Response.ok('ok');
      });

      final response = await handler(Request(
        'POST',
        Uri.parse('http://localhost/'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({'foo': 'bar'}),
      ));
      expect(response.statusCode, 200);
    });

    test('parses application/x-www-form-urlencoded', () async {
      final handler = const Pipeline()
          .addMiddleware(dsShelfBodyParserMiddleware())
          .addHandler((request) {
        expect(request.context['ds_shelf.body'], equals({'foo': 'bar', 'baz': 'qux'}));
        return Response.ok('ok');
      });

      final response = await handler(Request(
        'POST',
        Uri.parse('http://localhost/'),
        headers: {'content-type': 'application/x-www-form-urlencoded'},
        body: 'foo=bar&baz=qux',
      ));
      expect(response.statusCode, 200);
    });

    test('parses text/plain', () async {
      final handler = const Pipeline()
          .addMiddleware(dsShelfBodyParserMiddleware())
          .addHandler((request) {
        expect(request.context['ds_shelf.body'], equals('hello world'));
        return Response.ok('ok');
      });

      final response = await handler(Request(
        'POST',
        Uri.parse('http://localhost/'),
        headers: {'content-type': 'text/plain'},
        body: 'hello world',
      ));
      expect(response.statusCode, 200);
    });

    test('returns 400 for invalid JSON', () async {
      final handler = const Pipeline()
          .addMiddleware(dsShelfBodyParserMiddleware())
          .addHandler((_) => Response.ok('should not be reached'));

      final response = await handler(Request(
        'POST',
        Uri.parse('http://localhost/'),
        headers: {'content-type': 'application/json'},
        body: '{invalid json',
      ));
      expect(response.statusCode, 400);
      expect(await response.readAsString(), 'Invalid request body');
    });

    test('preserves body stream for downstream', () async {
      final handler = const Pipeline()
          .addMiddleware(dsShelfBodyParserMiddleware())
          .addHandler((request) async {
        // Body parser read it, but should have restored it using change(body: ...)
        final body = await request.readAsString();
        expect(body, '{"foo":"bar"}');
        expect(request.context['ds_shelf.body'], equals({'foo': 'bar'}));
        return Response.ok('ok');
      });

      final response = await handler(Request(
        'POST',
        Uri.parse('http://localhost/'),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({'foo': 'bar'}),
      ));
      expect(response.statusCode, 200);
    });
    
    test('handles empty body gracefully (empty JSON)', () async {
      final handler = const Pipeline()
          .addMiddleware(dsShelfBodyParserMiddleware())
          .addHandler((request) {
         // Should be null or empty map depending on implementation for empty body?
         // Our implementation: if content is empty -> return inner(request) (so context is missing)
         // Wait, let's verify implementation logic.
         // if (content.isEmpty) return inner(request);
         expect(request.context['ds_shelf.body'], isNull);
         return Response.ok('ok');
      });

       final response = await handler(Request(
        'POST',
        Uri.parse('http://localhost/'),
        headers: {'content-type': 'application/json'},
        body: '',
      ));
      expect(response.statusCode, 200);
    });
  });
}
