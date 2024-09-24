import 'package:ds_custom_middleware/src/routing/dynamic_routing.dart';
import 'package:ds_custom_middleware/src/model/ds_request_model.dart';

Future<String> testRouteParams() async {
  final router = Router();

  final request = DsCustomMiddleWareRequest(
    'GET',
    Uri.parse('/users/123/profile'),
    {},
    null,
  );

  final response = await router.handleRequest(request);

  return 'Route params test completed. Response: ${response.body}';
}
