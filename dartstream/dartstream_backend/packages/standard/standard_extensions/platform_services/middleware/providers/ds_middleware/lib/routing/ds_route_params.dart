import '../app/models/ds_custom_middleware_model.dart';

class DsRouteParamHandler {
  final RegExp _paramRegex = RegExp(r':(\w+)');

  Map<String, String> extractParams(String routePattern, String actualPath) {
    final paramNames = _paramRegex
        .allMatches(routePattern)
        .map((match) => match.group(1)!)
        .toList();

    final patternParts = routePattern.split('/');
    final actualParts = actualPath.split('/');

    final params = <String, String>{};

    for (var i = 0; i < patternParts.length; i++) {
      if (patternParts[i].startsWith(':')) {
        params[paramNames[params.length]] = actualParts[i];
      }
    }

    return params;
  }

  DsCustomMiddleWareRequest addParamsToRequest(
      DsCustomMiddleWareRequest request, String routePattern) {
    final params = extractParams(routePattern, request.uri.path);
    return request.copyWith(routeParams: params);
  }
}
