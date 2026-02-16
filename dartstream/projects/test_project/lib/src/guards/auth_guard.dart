import '../services/auth/ping_provider.dart';

/// RouteContext provides context information for route navigation
class RouteContext {
  final String path;
  final Map<String, dynamic> params;

  RouteContext({required this.path, this.params = const {}});
}

/// Base class for route guards in Dartstream
/// Guards control access to routes based on custom logic
abstract class RouteGuard {
  /// Check if the route can be activated
  /// Returns true to allow access, false to deny
  Future<bool> canActivate(RouteContext context);
}

/// AuthGuard enforces authentication using Ping Identity
/// Prevents unauthenticated users from accessing protected routes
class AuthGuard extends RouteGuard {
  final PingProvider _pingProvider = PingProvider();

  @override
  Future<bool> canActivate(RouteContext context) async {
    final isAuthenticated = _pingProvider.isLoggedIn();

    if (!isAuthenticated) {
      print('🔒 Access denied: User not authenticated');
      // In a real app, you might want to redirect to login page here
      return false;
    }

    print('✅ Access granted: User authenticated');
    return true;
  }
}

/// RoleGuard enforces role-based access control (RBAC)
/// Checks if user has required role claim from Ping Identity
class RoleGuard extends RouteGuard {
  final String requiredRole;
  final PingProvider _pingProvider = PingProvider();

  RoleGuard({required this.requiredRole});

  @override
  Future<bool> canActivate(RouteContext context) async {
    if (!_pingProvider.isLoggedIn()) {
      print('🔒 Access denied: User not authenticated');
      return false;
    }

    // Get user info and check role claim
    final userInfo = _pingProvider.getUserInfo();
    final roles = userInfo?['roles'] as List<dynamic>?;

    if (roles == null || !roles.contains(requiredRole)) {
      print(
        '🔒 Access denied: User does not have required role: $requiredRole',
      );
      return false;
    }

    print('✅ Access granted: User has required role: $requiredRole');
    return true;
  }
}

/// AttributeGuard enforces attribute-based access control (ABAC)
/// Checks if user has specific claim/attribute from Ping Identity
class AttributeGuard extends RouteGuard {
  final String attributeName;
  final dynamic expectedValue;
  final PingProvider _pingProvider = PingProvider();

  AttributeGuard({required this.attributeName, required this.expectedValue});

  @override
  Future<bool> canActivate(RouteContext context) async {
    if (!_pingProvider.isLoggedIn()) {
      print('🔒 Access denied: User not authenticated');
      return false;
    }

    // Get user info and check attribute
    final actualValue = _pingProvider.getClaim(attributeName);

    if (actualValue != expectedValue) {
      print(
        '🔒 Access denied: Attribute $attributeName does not match expected value',
      );
      return false;
    }

    print('✅ Access granted: Attribute $attributeName matches expected value');
    return true;
  }
}
