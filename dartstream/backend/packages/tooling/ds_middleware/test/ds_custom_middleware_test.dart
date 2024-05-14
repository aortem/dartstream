//import 'package:ds_custom_middleware/ds_custom_middleware.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

import '../example/ds_example_authentication.dart';

void main() {
  group('Authentication Middleware Test', () {
    test('Authenticated request', () async {
      // Define a list of authenticated users for testing
      final List<String> authenticatedUsers = ['user1', 'user2'];

      // Create an instance of AuthenticationMiddleware
      final authenticationMiddleware =
          DsCustomMiddleWareAuthenticationMiddleware(authenticatedUsers);

      // Create a sample authenticated request
      var request = DsCustomMiddleWareRequest('GET',
          Uri.parse('/authenticated/resource'), {'Authorization': 'user1'}, {});

      // Call the handle method of AuthenticationMiddleware with the authenticated request
      var response =
          await authenticationMiddleware.handle(request, (req) async {
        // This is a dummy handler, it should not be called for an authenticated request
        return DsCustomMiddleWareResponse.ok('Handler called');
      });

      // Assert that the response status code is 200 for an authenticated request
      expect(response.statusCode, equals(200));
      expect(response.body, equals('Handler called'));
    });

    test('Unauthenticated request', () async {
      // Define a list of authenticated users for testing
      final List<String> authenticatedUsers = ['user1', 'user2'];

      // Create an instance of AuthenticationMiddleware
      final authenticationMiddleware =
          DsCustomMiddleWareAuthenticationMiddleware(authenticatedUsers);

      // Create a sample unauthenticated request
      var request = DsCustomMiddleWareRequest(
          'GET', Uri.parse('/authenticated/resource'), {}, {});

      // Call the handle method of AuthenticationMiddleware with the unauthenticated request
      var response =
          await authenticationMiddleware.handle(request, (req) async {
        // This is a dummy handler, it should not be called for an unauthenticated request
        return DsCustomMiddleWareResponse.ok('Handler called');
      });

      // Assert that the response status code is 401 for an unauthenticated request
      expect(response.statusCode, equals(401));
      expect(response.body, equals('Unauthorized'));
    });

    // Add more test cases for edge cases, additional scenarios, etc.
  });
}
