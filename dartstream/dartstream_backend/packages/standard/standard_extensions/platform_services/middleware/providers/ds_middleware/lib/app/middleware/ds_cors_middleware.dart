import '../models/ds_custom_middleware_model.dart';

class DsCorsMiddleware {
  final List<String> allowedOrigins;
  final List<String> allowedMethods;
  final List<String> allowedHeaders;
  final bool allowCredentials;

  DsCorsMiddleware({
    this.allowedOrigins = const ['*'],
    this.allowedMethods = const ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    this.allowedHeaders = const ['Content-Type', 'Authorization'],
    this.allowCredentials = false,
  });

  Future<DsCustomMiddleWareResponse> handle(
    DsCustomMiddleWareRequest request,
    Future<DsCustomMiddleWareResponse> Function(DsCustomMiddleWareRequest) next,
  ) async {
    if (request.method == 'OPTIONS') {
      return _handlePreflight(request);
    }

    final response = await next(request);
    return _addCorsHeaders(response);
  }

  DsCustomMiddleWareResponse _handlePreflight(
      DsCustomMiddleWareRequest request) {
    return DsCustomMiddleWareResponse(204, _corsHeaders(request), null);
  }

  DsCustomMiddleWareResponse _addCorsHeaders(
      DsCustomMiddleWareResponse response) {
    final headers = Map<String, String>.from(response.headers)
      ..addAll(_corsHeaders(null));
    return response.copyWith(headers: headers);
  }

  Map<String, String> _corsHeaders(DsCustomMiddleWareRequest? request) {
    final origin = request?.headers['origin'];
    final headers = <String, String>{
      'Access-Control-Allow-Origin': allowedOrigins.contains('*') ||
              (origin != null && allowedOrigins.contains(origin))
          ? origin ?? '*'
          : allowedOrigins.first,
      'Access-Control-Allow-Methods': allowedMethods.join(', '),
      'Access-Control-Allow-Headers': allowedHeaders.join(', '),
      'Access-Control-Allow-Credentials': allowCredentials.toString(),
    };

    if (request?.method == 'OPTIONS') {
      headers['Access-Control-Max-Age'] = '86400'; // 24 hours
    }

    return headers;
  }
}
