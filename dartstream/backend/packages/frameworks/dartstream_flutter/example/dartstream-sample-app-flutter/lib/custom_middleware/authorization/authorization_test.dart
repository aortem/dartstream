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

  final authorizedResponse = await auth.authorize(
    authorizedRequest,
    'read_sensitive_data',
    (req) async => DsCustomMiddleWareResponse.ok('Sensitive data'),
  );

  final unauthorizedResponse = await auth.authorize(
    unauthorizedRequest,
    'read_sensitive_data',
    (req) async => DsCustomMiddleWareResponse.ok('Sensitive data'),
  );

  return 'Authorized response status: ${authorizedResponse.statusCode}\n'
      'Unauthorized response status: ${unauthorizedResponse.statusCode}';
}
