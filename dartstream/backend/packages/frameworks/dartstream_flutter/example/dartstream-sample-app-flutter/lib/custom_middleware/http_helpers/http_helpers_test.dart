import 'package:ds_custom_middleware/shared/utilities/ds_http_helpers.dart';

String testHttpHelpers() {
  final redirectResponse = DsHttpHelpers.redirect('/new-location');
  final jsonResponse = DsHttpHelpers.json({'key': 'value'});
  return 'Redirect: ${redirectResponse.statusCode}, JSON: ${jsonResponse.body}';
}
