import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';
import 'package:test/test.dart';
import '../../../example/ds_example_authentication.dart';

void main() {
  group('Authentication Middleware Test', () {
    test('Authenticated request', () async {
      final List<String> authenticatedUsers = ['user1', 'user2'];

      final authenticationMiddleware =
          DsCustomMiddleWareAuthenticationMiddleware(authenticatedUsers);

      var request = DsCustomMiddleWareRequest('GET',
          Uri.parse('/authenticated/resource'), {'Authorization': 'user1'}, {}, <String, String>{});

      var response =
          await authenticationMiddleware.handle(request, (req) async {
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
          'GET', Uri.parse('/authenticated/resource'), {}, {}, <String, String>{});

      var response =
          await authenticationMiddleware.handle(request, (req) async {
        return DsCustomMiddleWareResponse.ok('Handler called');
      });

      expect(response.statusCode, equals(401));
    });
  });
}
