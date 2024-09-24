import '../model/ds_request_model.dart';
import '../model/ds_response_model.dart';

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
    final origin = request.headers['Origin'];
    if (origin == null || !_isAllowedOrigin(origin)) {
      return await next(request);
    }

    if (request.method == 'OPTIONS') {
      return _handlePreflight(request);
    }

    final response = await next(request);
    return _addCorsHeaders(response, origin);
  }

  bool _isAllowedOrigin(String origin) {
    return allowedOrigins.contains('*') || allowedOrigins.contains(origin);
  }

  DsCustomMiddleWareResponse _handlePreflight(
      DsCustomMiddleWareRequest request) {
    final headers = {
      'Access-Control-Allow-Origin': request.headers['Origin'] ?? '*',
      'Access-Control-Allow-Methods': allowedMethods.join(', '),
      'Access-Control-Allow-Headers': allowedHeaders.join(', '),
      'Access-Control-Allow-Credentials': allowCredentials.toString(),
    };
    return DsCustomMiddleWareResponse(204, headers, null);
  }

  DsCustomMiddleWareResponse _addCorsHeaders(
      DsCustomMiddleWareResponse response, String origin) {
    final headers = Map<String, String>.from(response.headers);
    headers['Access-Control-Allow-Origin'] = origin;
    headers['Access-Control-Allow-Credentials'] = allowCredentials.toString();
    return response.copyWith(headers: headers);
  }
}
