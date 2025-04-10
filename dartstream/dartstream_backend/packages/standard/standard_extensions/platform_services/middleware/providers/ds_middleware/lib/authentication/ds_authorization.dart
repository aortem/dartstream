import 'package:ds_custom_middleware/app/models/ds_custom_middleware_model.dart';

class DsAuthorization {
  final Map<String, List<String>> _rolePermissions = {};

  void addRole(String role, List<String> permissions) {
    _rolePermissions[role] = permissions;
  }

  bool hasPermission(String role, String permission) {
    return _rolePermissions[role]?.contains(permission) ?? false;
  }

  Future<DsCustomMiddleWareResponse> authorize(
    DsCustomMiddleWareRequest request,
    Future<DsCustomMiddleWareResponse> Function(DsCustomMiddleWareRequest) next,
    String requiredPermission,
  ) async {
    final userRole = request.headers['X-User-Role'];
    if (userRole == null) {
      return DsCustomMiddleWareResponse(401, {}, 'Unauthorized');
    }

    if (!hasPermission(userRole, requiredPermission)) {
      return DsCustomMiddleWareResponse(403, {}, 'Forbidden');
    }

    return next(request);
  }
}

class DsAuthorizationMiddleware {
  final DsAuthorization _auth = DsAuthorization();

  DsAuthorizationMiddleware() {
    // Initialize with some default roles and permissions
    _auth.addRole('admin', ['read', 'write', 'delete']);
    _auth.addRole('user', ['read']);
  }

  Future<DsCustomMiddleWareResponse> handle(
    DsCustomMiddleWareRequest request,
    Future<DsCustomMiddleWareResponse> Function(DsCustomMiddleWareRequest) next,
    String requiredPermission,
  ) async {
    return _auth.authorize(request, next, requiredPermission);
  }
}

// Decorator for easy application of authorization to routes
Function authorizeRoute(String requiredPermission) {
  return (Function handler) {
    return (DsCustomMiddleWareRequest request) async {
      final authMiddleware = DsAuthorizationMiddleware();
      return authMiddleware.handle(
        request,
        (req) async => await handler(req),
        requiredPermission,
      );
    };
  };
}
