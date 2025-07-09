import '../model/ds_request_model.dart';

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
