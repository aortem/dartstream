// Interface for all auth providers

// extensions/auth/ds_auth_manager.dart

import 'auth_provider.dart';
import 'firebase_auth_provider.dart';
import 'cognito_auth_provider.dart';
import 'active_directory_auth_provider.dart';

class AuthManager {
  final AuthProvider _provider;

  AuthManager._(this._provider);

  factory AuthManager({required String providerType}) {
    switch (providerType) {
      case 'firebase':
        return AuthManager._(FirebaseAuthProvider(/* Firebase config */));
      case 'cognito':
        return AuthManager._(CognitoAuthProvider(/* Cognito config */));
      default:
        throw UnimplementedError(
            'Unsupported authentication provider: $providerType');
    }
  }

  Future<void> signIn(String username, String password) =>
      _provider.signIn(username, password);
  Future<void> signOut() => _provider.signOut();
  Future<User> getUser(String userId) => _provider.getUser(userId);
  Future<bool> verifyToken(String token) => _provider.verifyToken(token);
}
