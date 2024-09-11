import 'package:ds_custom_middleware/ds_custom_middleware.dart';
import 'package:ds_custom_middleware/routing/ds_route_params.dart';

String testRouteParams() {
  final routeParamHandler = DsRouteParamHandler();
  final request = DsCustomMiddleWareRequest(
    'GET',
    Uri.parse('http://localhost:8080/users/123'),
    {},
    null,
    {},
  );
  final updatedRequest =
      routeParamHandler.addParamsToRequest(request, '/users/:userId');
  return 'Route param extracted: ${updatedRequest.routeParams['userId']}';
}
