import 'package:ds_custom_middleware/src/model/ds_request_model.dart';
import 'package:ds_custom_middleware/src/routing/dynamic_routing.dart';
import 'package:ds_custom_middleware/src/routing/index_routing.dart';
import 'package:ds_custom_middleware/src/routing/nested_router.dart';
import 'package:ds_custom_middleware/src/routing/print_router.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

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
        {},
        null,
      );

      final response = await router.handleRequest(request);

      expect(response.statusCode, 200);
      expect(response.body, 'Fetching user with ID 123...');
    });

    test('Index Routing Test', () async {
      final request = DsCustomMiddleWareRequest(
        'GET',
        Uri.parse('/index'),
        {},
        null,
      );

      final response = await indexRouter.handleIndexRequest(request);

      expect(response.statusCode, 200);
      expect(response.body, 'Welcome to the homepage!');
    });

    test('Print Routing Test', () async {
      final request = DsCustomMiddleWareRequest(
        'GET',
        Uri.parse('/print/someinfo'),
        {'Accept': 'text/plain'},
        null,
      );

      final response = await printRouter.handlePrintRequest(request);

      expect(response.statusCode, 200);
      expect(
          response.body, 'Request details have been printed to the console.');
    });

    test('Nested Routing Test', () async {
      final request = DsCustomMiddleWareRequest(
        'GET',
        Uri.parse('/users/123/profile'),
        {},
        null,
      );

      final response = await nestedRouter.handleNestedRequest(request);

      expect(response.statusCode, 200);
      expect(response.body, 'Fetching profile for user with ID 123...');
    });

    test('Not Found Routing Test', () async {
      final request = DsCustomMiddleWareRequest(
        'GET',
        Uri.parse('/unknown'),
        {},
        null,
      );

      final response = await router.handleRequest(request);

      expect(response.statusCode, 404);
      expect(response.body, 'Not Found');
    });
  });
}
