import '../model/ds_request_model.dart';
import '../model/ds_response_model.dart';

class RouteParams {
  final Map<String, String> _paramDefinitions = {};
  final Map<String, Function(Map<String, String>, DsCustomMiddleWareRequest)>
      _handlers = {};

  void addRoute(String path,
      Function(Map<String, String>, DsCustomMiddleWareRequest) handler) {
    final parts = path.split('/');
    final paramNames = <String>[];
    for (var i = 0; i < parts.length; i++) {
      if (parts[i].startsWith(':')) {
        paramNames.add(parts[i].substring(1));
        parts[i] = r'([^/]+)';
      }
    }
    final pattern = '^${parts.join('/')}';
    _paramDefinitions[pattern] = paramNames.join(',');
    _handlers[pattern] = handler;
  }

  Future<DsCustomMiddleWareResponse> handleRequest(
      DsCustomMiddleWareRequest request) async {
    final path = request.uri.path;
    for (var pattern in _paramDefinitions.keys) {
      final match = RegExp(pattern).firstMatch(path);
      if (match != null) {
        final paramNames = _paramDefinitions[pattern]!.split(',');
        final params = <String, String>{};
        for (var i = 0; i < paramNames.length; i++) {
          params[paramNames[i]] = match.group(i + 1)!;
        }
        return await _handlers[pattern]!(params, request);
      }
    }
    return DsCustomMiddleWareResponse.notFound();
  }
}
