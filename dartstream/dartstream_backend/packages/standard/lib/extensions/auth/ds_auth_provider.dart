// Factory for provider selection

// extensions/auth/ds_auth_provider.dart

abstract class AuthProvider {
  Future<void> signIn(String username, String password);
  Future<void> signOut();
  Future<User> getUser(String userId);
  Future<bool> verifyToken(String token);
}

class User {
  final String id;
  final String email;
  final String displayName;

  User({
    required this.id,
    required this.email,
    required this.displayName,
  });
}
