import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';
import 'package:test/test.dart';
import 'package:ds_middleware/src/routing/dynamic_routing.dart';

void main() {
  group('Router Tests', () {
    late Router router;

    setUp(() {
      router = Router();
    });

    test('Dynamic Routing Test', () async {
      final request = DsCustomMiddleWareRequest(
        method: 'GET',
        uri: Uri.parse('/users/123'),
        headers: <String, String>{},
        body: null,
        queryParams: <String, String>{},
      );
      final response = await router.handleRequest(request);
      expect(response.statusCode, 200);
      expect(response.body, contains('123'));
    });
  });
}
