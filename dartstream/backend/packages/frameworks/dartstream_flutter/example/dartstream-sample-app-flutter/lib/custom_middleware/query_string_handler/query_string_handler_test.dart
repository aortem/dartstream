import 'package:ds_custom_middleware/ds_custom_middleware.dart';
import 'package:ds_custom_middleware/routing/ds_query_string_handler.dart';

String testQueryStringHandler() {
  final queryStringHandler = DsQueryStringHandler();
  final request = DsCustomMiddleWareRequest(
    'GET',
    Uri.parse('http://localhost:8080/api?key1=value1&key2=value2'),
    {},
    null,
    {},
  );
  final updatedRequest = queryStringHandler.addQueryParamsToRequest(request);
  return 'Query parsed: ${updatedRequest.queryParams['key1']}';
}
