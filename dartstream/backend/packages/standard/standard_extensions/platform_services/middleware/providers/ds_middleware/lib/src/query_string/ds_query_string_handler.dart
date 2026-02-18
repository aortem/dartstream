<<<<<<< HEAD
import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';
=======
import '../../app/models/ds_custom_middleware_model.dart';
>>>>>>> development

class DsQueryStringHandler {
  static Map<String, String> parse(DsCustomMiddleWareRequest request) {
    return request.uri.queryParameters;
  }

  static String? getValue(DsCustomMiddleWareRequest request, String key) {
    return request.uri.queryParameters[key];
  }

  static List<String> getValues(DsCustomMiddleWareRequest request, String key) {
    return request.uri.queryParametersAll[key] ?? [];
  }

  static bool hasKey(DsCustomMiddleWareRequest request, String key) {
    return request.uri.queryParameters.containsKey(key);
  }

  static Map<String, String> getAll(DsCustomMiddleWareRequest request) {
    return Map.from(request.uri.queryParameters);
  }
}
