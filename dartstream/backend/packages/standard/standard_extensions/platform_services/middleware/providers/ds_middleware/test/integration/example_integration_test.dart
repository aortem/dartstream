import 'package:ds_middleware/ds_custom_middleware.dart';
import 'package:test/test.dart';

class AddHeaderMiddleware implements DsCustomMiddleware {
  @override
  Future<DsCustomMiddleWareResponse> handle(DsCustomMiddleWareRequest request, Future<DsCustomMiddleWareResponse> Function(DsCustomMiddleWareRequest) next) async {
    final response = await next(request);
    response.headers['X-Processed-By'] = 'DartStream';
    return response;
  }
}

void main() {
  group('Middleware Integration', () {
    test('AddHeaderMiddleware adds x-processed-by header', () async {
      final middleware = AddHeaderMiddleware();
      final request = DsCustomMiddleWareRequest('GET', Uri.parse('http://localhost/test'), {}, null, {});
      final response = await middleware.handle(request, (req) async => DsCustomMiddleWareResponse.ok('Success'));
      expect(response.statusCode, 200);
      expect(response.headers['X-Processed-By'], equals('DartStream'));
    });
  });
}
