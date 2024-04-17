import '../models/ds_custom_middleware_request_data.dart';
import '../models/ds_custom_middleware_response_data.dart';

abstract class DsCustomMiddlewareContract {
  void interceptRequest({RequestData data});

  void interceptResponse({ResponseData data});
}
