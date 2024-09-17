import 'package:ds_custom_middleware/ds_custom_middleware.dart';

Future<String> testAuthorization() async {
  final auth = DsAuthorization();
  auth.addRolePermission('admin', 'read_sensitive_data');

  final authorizedRequest = DsCustomMiddleWareRequest(
    'GET',
    Uri.parse('/sensitive-data'),
    {'X-User-Role': 'admin'},
    null,
  );

  final unauthorizedRequest = DsCustomMiddleWareRequest(
    'GET',
    Uri.parse('/sensitive-data'),
    {'X-User-Role': 'user'},
    null,
  );

  final noRoleRequest = DsCustomMiddleWareRequest(
    'GET',
    Uri.parse('/sensitive-data'),
    {},
    null,
  );

  final authorizedResponse = await auth.authorize(
    authorizedRequest,
    'read_sensitive_data',
    (req) async => DsCustomMiddleWareResponse.ok('Access granted'),
  );

  final unauthorizedResponse = await auth.authorize(
    unauthorizedRequest,
    'read_sensitive_data',
    (req) async => DsCustomMiddleWareResponse.ok('This should not be seen'),
  );

  final noRoleResponse = await auth.authorize(
    noRoleRequest,
    'read_sensitive_data',
    (req) async => DsCustomMiddleWareResponse.ok('This should not be seen'),
  );

  return 'Authorization Test Results:\n'
      'Authorized request (admin):\n'
      '  Status: ${authorizedResponse.statusCode}\n'
      '  Body: ${authorizedResponse.body}\n\n'
      'Unauthorized request (user):\n'
      '  Status: ${unauthorizedResponse.statusCode}\n'
      '  Body: ${unauthorizedResponse.body}\n\n'
      'No role request:\n'
      '  Status: ${noRoleResponse.statusCode}\n'
      '  Body: ${noRoleResponse.body}';
}
