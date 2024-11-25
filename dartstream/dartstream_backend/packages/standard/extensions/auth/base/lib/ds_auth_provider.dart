// extensions/auth/ds_auth_provider.dart

abstract class DSAuthProvider {
  Future<void> signIn(String username, String password);
  Future<void> signOut();
  Future<DSAuthUser> getUser(String userId);
  Future<bool> verifyToken(String token);
}

// Standardized User model to ensure consistent structure across providers
class DSAuthUser {
  final String id;
  final String email;
  final String displayName;

  DSAuthUser({
    required this.id,
    required this.email,
    required this.displayName,
  });
}
