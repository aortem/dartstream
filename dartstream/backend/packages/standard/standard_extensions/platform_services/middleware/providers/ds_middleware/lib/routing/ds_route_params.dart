import '../app/models/ds_custom_middleware_model.dart';

class DsRouteParamHandler {
  Map<String, dynamic> extractParams(String routePattern, String actualPath) {
    final patternParts = routePattern.split('/');
    final actualParts = actualPath.split('/');
    final params = <String, dynamic>{};

    for (var i = 0; i < patternParts.length; i++) {
      final patternPart = patternParts[i];

      if (patternPart == '*') {
        params['wildcard'] = i < actualParts.length
            ? actualParts.skip(i).where((part) => part.isNotEmpty).join('/')
            : '';
        continue;
      }

      if (!patternPart.startsWith(':')) {
        continue;
      }

      final isOptional = patternPart.endsWith('?');
      final rawToken = patternPart.substring(
        1,
        isOptional ? patternPart.length - 1 : null,
      );
      final typeMatch = RegExp(
        r'^(\w+)\((int|double|bool)\)$',
      ).firstMatch(rawToken);
      final name = typeMatch?.group(1) ?? rawToken;
      final type = typeMatch?.group(2);

      if (i >= actualParts.length || actualParts[i].isEmpty) {
        if (isOptional) {
          continue;
        }
        throw Exception('Missing required route parameter: $name');
      }

      params[name] = _coerceValue(name, actualParts[i], type);
    }

    return params;
  }

  dynamic _coerceValue(String name, String value, String? type) {
    switch (type) {
      case 'int':
        final parsed = int.tryParse(value);
        if (parsed == null) {
          throw Exception('Invalid int route parameter: $name');
        }
        return parsed;
      case 'double':
        final parsed = double.tryParse(value);
        if (parsed == null) {
          throw Exception('Invalid double route parameter: $name');
        }
        return parsed;
      case 'bool':
        if (value == 'true') return true;
        if (value == 'false') return false;
        throw Exception('Invalid bool route parameter: $name');
      default:
        return value;
    }
  }

  DsCustomMiddleWareRequest addParamsToRequest(
    DsCustomMiddleWareRequest request,
    String routePattern,
  ) {
    final params = extractParams(routePattern, request.uri.path);
    return request.copyWith(routeParams: params);
  }
}
