import 'package:ds_custom_middleware/src/http_helpers/ds_http_helpers.dart';
import 'package:ds_custom_middleware/src/model/ds_request_model.dart';

String testHttpHelpers() {
  final jsonResponse = DsHttpHelpers.jsonResponse({'message': 'Hello, World!'});

  final redirectResponse = DsHttpHelpers.redirect('https://example.com');

  final request = DsCustomMiddleWareRequest(
    'GET',
    Uri.parse('/test'),
    {'X-Forwarded-For': '192.168.1.1'},
    null,
  );

  final clientIp = DsHttpHelpers.getClientIp(request);

  return 'JSON Response: ${jsonResponse.body}\n'
      'Redirect Response: ${redirectResponse.headers['Location']}\n'
      'Client IP: $clientIp';
}
