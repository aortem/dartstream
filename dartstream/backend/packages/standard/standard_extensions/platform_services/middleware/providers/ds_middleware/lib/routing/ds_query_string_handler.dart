import '../app/models/ds_custom_middleware_model.dart';

class DsQueryStringHandler {
  Map<String, String> parseQueryString(String queryString) {
    if (queryString.isEmpty) return {};

    return Uri.splitQueryString(queryString).map((key, value) {
      if (value.contains(',')) {
        return MapEntry(key, value.split(',').join(','));
      }
      return MapEntry(key, value);
    });
  }

  DsCustomMiddleWareRequest addQueryParamsToRequest(
      DsCustomMiddleWareRequest request) {
    final queryParams = parseQueryString(request.uri.query);
    return request.copyWith(queryParams: queryParams);
  }
}
