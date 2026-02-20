import 'package:ds_tools_testing/ds_tools_testing.dart';
import 'package:ds_middleware/ds_custom_middleware.dart';

// --- 1. Code Under Test ---

// A simple middleware that adds a header
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

// --- 2. The Integration Test ---

void main() {
  group('Middleware Integration', () {
    test('AddHeaderMiddleware adds x-processed-by header', () async {
      // ARRANGE
      final middleware = AddHeaderMiddleware();
      final request = DsCustomMiddleWareRequest(
        'GET',
        Uri.parse('http://localhost/test'),
        {},
        null,
        {},
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
