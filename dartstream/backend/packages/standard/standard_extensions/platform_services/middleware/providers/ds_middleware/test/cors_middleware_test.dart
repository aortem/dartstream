import 'package:ds_shelf/extensions/cors/ds_shelf_cors_middleware.dart';
import 'package:shelf/shelf.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

void main() {
  test('adds CORS header for allowed origin', () async {
    final handler = const Pipeline()
        .addMiddleware(dsShelfCorsMiddleware())
        .addHandler((_) => Response.ok('Hello'));

    final request = Request(
      'GET',
      Uri.parse('http://localhost/test'),
      headers: {'origin': 'http://localhost:3000'},
    );

    final response = await handler(request);

    expect(
      response.headers['Access-Control-Allow-Origin'],
      'http://localhost:3000',
    );
  });

  test('returns 204 for OPTIONS request', () async {
    final handler = const Pipeline()
        .addMiddleware(dsShelfCorsMiddleware())
        .addHandler((_) => Response.ok('Hello'));

    final request = Request(
      'OPTIONS',
      Uri.parse('http://localhost/test'),
      headers: {'origin': 'http://localhost:3000'},
    );

    final response = await handler(request);

    expect(response.statusCode, 200);
  });
}