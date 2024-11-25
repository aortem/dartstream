import '../model/ds_request_model.dart';
import '../model/ds_response_model.dart';

class DsAuthorization {
  final Map<String, Set<String>> _rolePermissions = {};

  void addRolePermission(String role, String permission) {
    _rolePermissions.putIfAbsent(role, () => {}).add(permission);
  }

  Future<DsCustomMiddleWareResponse> authorize(
    DsCustomMiddleWareRequest request,
    String requiredPermission,
    Future<DsCustomMiddleWareResponse> Function(DsCustomMiddleWareRequest) next,
  ) async {
    final userRole = request.headers['X-User-Role'];
    if (userRole == null) {
      return DsCustomMiddleWareResponse.unauthorized();
    }

    final permissions = _rolePermissions[userRole];
    if (permissions == null || !permissions.contains(requiredPermission)) {
      return DsCustomMiddleWareResponse(
        403,
        {},
        'Forbidden: Insufficient permissions',
      );
    }

    return await next(request);
  }
}
