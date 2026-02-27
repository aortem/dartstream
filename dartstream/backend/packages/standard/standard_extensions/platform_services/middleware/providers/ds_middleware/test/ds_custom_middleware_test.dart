import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

import '../../../example/ds_example_authentication.dart';


void main() {
  group('Authentication Middleware Test', () {
    test('Authenticated request', () async {
      final List<String> authenticatedUsers = ['user1', 'user2'];

      final authenticationMiddleware =
          DsCustomMiddleWareAuthenticationMiddleware(authenticatedUsers);

      // Create a sample authenticated request
      var request = DsCustomMiddleWareRequest('GET',
<<<<<<< HEAD:dartstream/backend/packages/standard/standard_extensions/platform_services/middleware/providers/ds_middleware/test/ds_custom_middleware_test.dart
          Uri.parse('/authenticated/resource'), {'Authorization': 'user1'}, {}, {});
=======
          Uri.parse('/authenticated/resource'), {'Authorization': 'user1'}, {}, <String, String>{});
      var response =
        // This is a dummy handler, it should not be called for an authenticated request
        return DsCustomMiddleWareResponse.ok('Handler called');
      });

      expect(response.statusCode, equals(200));
      expect(response.body, equals('Handler called'));
    });

    test('Unauthenticated request', () async {
      final List<String> authenticatedUsers = ['user1', 'user2'];

      final authenticationMiddleware =
          DsCustomMiddleWareAuthenticationMiddleware(authenticatedUsers);

      var request = DsCustomMiddleWareRequest(
        'GET',
        Uri.parse('/authenticated/resource'),
        {},
        {},
        <String, String>{},
      );

      var response = await authenticationMiddleware.handle(request, (
        req,
      ) async {
        return DsCustomMiddleWareResponse.ok('Handler called');
      });

      expect(response.statusCode, equals(401));
    });
  });
}
