import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';
import 'package:test/test.dart';
import 'package:ds_middleware/src/routing/dynamic_routing.dart';
import 'package:ds_middleware/src/routing/index_routing.dart';
import 'package:ds_middleware/src/routing/nested_router.dart';
import 'package:ds_middleware/src/routing/print_router.dart';

void main() {
  group('Router Tests', () {
    late Router router;
    late IndexRouter indexRouter;
    late PrintRouter printRouter;
    late NestedRouter nestedRouter;

    setUp(() {
      router = Router();
      indexRouter = IndexRouter();
      printRouter = PrintRouter();
      nestedRouter = NestedRouter();
    });

    test('Dynamic Routing Test', () async {
      final request = DsCustomMiddleWareRequest(
        'GET',
        Uri.parse('/users/123'),
        <String, String>{},
        null,
        <String, String>{},
      );
      final response = await router.handleRequest(request);
      expect(response.statusCode, 200);
      expect(response.body, contains('123'));
    });
  });
}
