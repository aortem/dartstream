// Interface for all Auth Providers

abstract class DSAuthProvider {
  Future<void> initialize(Map<String, dynamic> config);
  Future<void> signIn(String username, String password);
  Future<void> signOut();
  Future<DSAuthUser> getUser(String userId);
  Future<bool> verifyToken(String token);
  Future<String> refreshToken(String refreshToken);

  // Lifecycle hooks
  Future<void> onLoginSuccess(DSAuthUser user) async {}
  Future<void> onLogout() async {}
}

// Standardized User model for consistent structure across providers
class DSAuthUser {
  final String id;
  final String email;
  final String displayName;
  final Map<String, dynamic>? customAttributes;

  DSAuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    this.customAttributes,
  });
}

// Custom exception for handling errors in authentication
class DSAuthError implements Exception {
  final String message;
  final int? code;

  DSAuthError(this.message, {this.code});

  @override
  String toString() => 'DSAuthError: $message (Code: $code)';
}
