import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:ds_error_handling/ds_error_handling.dart';

void main() {
  group('DSError Serialization', () {
    test('NotFoundError serializes correctly', () {
      final error = NotFoundError('Item not found');
      expect(error.statusCode, 404);
      expect(error.toJson(), {
        'error': {'type': 'NotFoundError', 'message': 'Item not found'}
      });
    });

    test('ValidationError serializes correctly', () {
      final error = ValidationError('Bad input');
      expect(error.statusCode, 400);
      expect(error.toJson(), {
        'error': {'type': 'ValidationError', 'message': 'Bad input'}
      });
    });
  });

  group('dsErrorMiddleware Integration', () {
    late Handler handler;

    setUp(() {
      final innerHandler = (Request request) {
        if (request.url.path == 'success') return Response.ok('Success');
        if (request.url.path == 'notfound') throw NotFoundError('Not Here');
        if (request.url.path == 'validation') throw ValidationError('Invalid');
        throw Exception('Boom');
      };

      handler = Pipeline()
          .addMiddleware(dsErrorMiddleware(onError: (e, s) {
            // Silence logs during tests
          }))
          .addHandler(innerHandler);
    });

    test('returns 200 for successful requests', () async {
      final response = await handler(Request('GET', Uri.parse('http://localhost/success')));
      expect(response.statusCode, 200);
      expect(await response.readAsString(), 'Success');
    });

    test('returns 404 for NotFoundError', () async {
      final response = await handler(Request('GET', Uri.parse('http://localhost/notfound')));
      expect(response.statusCode, 404);
      final body = jsonDecode(await response.readAsString());
      expect(body['error']['type'], 'NotFoundError');
    });

    test('returns 500 for unhandled exceptions', () async {
      final response = await handler(Request('GET', Uri.parse('http://localhost/crash')));
      expect(response.statusCode, 500);
      final body = jsonDecode(await response.readAsString());
      expect(body['error']['type'], 'InternalServerError');
      expect(body['error']['message'], 'An unexpected error occurred.');
    });
  });
}
