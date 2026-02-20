import 'package:ds_middleware/ds_custom_middleware.dart';
import 'package:ds_tools_testing/ds_tools_testing.dart';

// Assuming this exists based on imports, but we might need to check its actual path/existence
import '../../../example/ds_example_authentication.dart';

void main() {
  group('Authentication Middleware Test', () {
    test('Authenticated request', () async {
      final List<String> authenticatedUsers = ['user1', 'user2'];
      final authenticationMiddleware =
          DsCustomMiddleWareAuthenticationMiddleware(authenticatedUsers);

      final request = DsCustomMiddleWareRequest(
        'GET',
        Uri.parse('/authenticated/resource'),
        {'Authorization': 'user1'},
        null,
        {},
      );

      final response = await authenticationMiddleware.handle(request, (
        req,
      ) async {
        return DsCustomMiddleWareResponse.ok('Handler called');
      });

      expect(response.statusCode, equals(200));
      expect(response.body, equals('Handler called'));
    });

    test('Unauthenticated request', () async {
      final List<String> authenticatedUsers = ['user1', 'user2'];
      final authenticationMiddleware =
          DsCustomMiddleWareAuthenticationMiddleware(authenticatedUsers);

      final request = DsCustomMiddleWareRequest(
        'GET',
        Uri.parse('/authenticated/resource'),
        {},
        null,
        {},
      );

      final response = await authenticationMiddleware.handle(request, (
        req,
      ) async {
        return DsCustomMiddleWareResponse.ok('Handler called');
      });

      expect(response.statusCode, equals(401));
      // Note: The middleware returns a Map body for JSON by default in some constructors,
      // but unauthorized() usually has a specific message or empty body.
      // Let's check what unauthorized() actually returns.
    });
  });
}
