import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

import '../example/ds_example_authentication.dart';

void main() {
  group('Authentication Middleware Test', () {
    test('authenticated request calls next handler', () async {
      final authenticatedUsers = ['user1', 'user2'];
      final authenticationMiddleware =
          DsCustomMiddleWareAuthenticationMiddleware(authenticatedUsers);

      final request = DsCustomMiddleWareRequest(
        method: 'GET',
        uri: Uri.parse('/authenticated/resource'),
        headers: {'Authorization': 'user1'},
      );

      final response = await authenticationMiddleware.handle(request, (
        req,
      ) async {
        return DsCustomMiddleWareResponse.ok('Handler called');
      });

      expect(response.statusCode, equals(200));
      expect(response.body, equals('Handler called'));
    });

    test('unauthenticated request returns unauthorized', () async {
      final authenticatedUsers = ['user1', 'user2'];
      final authenticationMiddleware =
          DsCustomMiddleWareAuthenticationMiddleware(authenticatedUsers);

      final request = DsCustomMiddleWareRequest(
        method: 'GET',
        uri: Uri.parse('/authenticated/resource'),
        headers: {},
      );

      final response = await authenticationMiddleware.handle(request, (
        req,
      ) async {
        return DsCustomMiddleWareResponse.ok('Handler called');
      });

      expect(response.statusCode, equals(401));
    });
  });
}
