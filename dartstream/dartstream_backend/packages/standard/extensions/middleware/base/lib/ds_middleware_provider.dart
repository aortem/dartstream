// extensions/auth/ds_auth_provider.dart

abstract class DSAuthProvider {
  Future<void> signIn(String username, String password);
  Future<void> signOut();
  Future<DSUser> getUser(String userId);
  Future<bool> verifyToken(String token);
}

// Standardized User model to ensure consistent structure across providers
class DSUser {
  final String id;
  final String email;
  final String displayName;

  DSUser({
    required this.id,
    required this.email,
    required this.displayName,
  });
}
