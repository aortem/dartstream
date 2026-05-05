import '../../app/models/ds_custom_middleware_model.dart';

class DsCorsMiddleware {
  final List<String> allowedOrigins;
  final List<String> allowedMethods;
  final List<String> allowedHeaders;
  final List<String> exposedHeaders;
  final bool allowCredentials;
  final int? maxAge;

  DsCorsMiddleware({
    this.allowedOrigins = const ['*'],
    this.allowedMethods = const ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    this.allowedHeaders = const ['Content-Type', 'Authorization'],
    this.exposedHeaders = const [],
    this.allowCredentials = false,
    this.maxAge,
  });

  Future<DsCustomMiddleWareResponse> handle(
    DsCustomMiddleWareRequest request,
    Future<DsCustomMiddleWareResponse> Function(DsCustomMiddleWareRequest) next,
  ) async {
    final origin = request.headers['Origin'];

    if (origin == null || !_isAllowedOrigin(origin)) {
      return await next(request);
    }

    if (request.method == 'OPTIONS') {
      return _handlePreflight(origin);
    }

    final response = await next(request);
    return _addCorsHeaders(response, origin);
  }

  bool _isAllowedOrigin(String origin) {
    return allowedOrigins.contains('*') || allowedOrigins.contains(origin);
  }

  DsCustomMiddleWareResponse _handlePreflight(String origin) {
    final headers = _buildCorsHeaders(origin);

    headers['Access-Control-Allow-Methods'] = allowedMethods.join(', ');
    headers['Access-Control-Allow-Headers'] = allowedHeaders.join(', ');

    if (maxAge != null) {
      headers['Access-Control-Max-Age'] = maxAge.toString();
    }

    return DsCustomMiddleWareResponse(204, headers, null);
  }

  DsCustomMiddleWareResponse _addCorsHeaders(
    DsCustomMiddleWareResponse response,
    String origin,
  ) {
    final headers = Map<String, String>.from(response.headers);
    headers.addAll(_buildCorsHeaders(origin));

    if (exposedHeaders.isNotEmpty) {
      headers['Access-Control-Expose-Headers'] = exposedHeaders.join(', ');
    }

    return response.copyWith(headers: headers);
  }

  Map<String, String> _buildCorsHeaders(String origin) {
    final headers = <String, String>{};

    if (allowedOrigins.contains('*') && !allowCredentials) {
      headers['Access-Control-Allow-Origin'] = '*';
    } else {
      headers['Access-Control-Allow-Origin'] = origin;
    }

    if (allowCredentials) {
      headers['Access-Control-Allow-Credentials'] = 'true';
    }

    return headers;
  }
}
