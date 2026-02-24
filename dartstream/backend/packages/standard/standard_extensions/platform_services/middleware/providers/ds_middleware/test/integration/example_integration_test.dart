import 'package:test/test.dart';
import 'package:ds_middleware/ds_custom_middleware.dart';

class AddHeaderMiddleware implements DsCustomMiddleware {
  @override
  Future<DsCustomMiddleWareResponse> handle(
    DsCustomMiddleWareRequest request,
    Future<DsCustomMiddleWareResponse> Function(DsCustomMiddleWareRequest) next,
  ) async {
    // Process request
    final response = await next(request);

    // Modify response
    response.headers['X-Processed-By'] = 'DartStream';
    return response;
  }
}

void main() {
  group('Middleware Integration', () {
    test('AddHeaderMiddleware adds x-processed-by header', () async {
      final middleware = AddHeaderMiddleware();
      final request = DsCustomMiddleWareRequest(
        'GET',
        Uri.parse('http://localhost/test'),
        <String, String>{},
        null,
        <String, String>{},
      );

      // ACT: simulate the middleware chain
      final response = await middleware.handle(request, (req) async {
        return DsCustomMiddleWareResponse.ok('Success');
      });

      // ASSERT
      expect(response.statusCode, 200);
      expect(response.headers['X-Processed-By'], equals('DartStream'));
    });
  });
}
