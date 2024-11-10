// Interface for all auth providers

// extensions/auth/ds_auth_manager.dart

import 'ds_auth_provider.dart';
import 'ds_firebase_auth_provider.dart';
import 'ds_cognito_auth_provider.dart';
import 'ds_azure_ad_b2c_auth_provider.dart';

class AuthManager {
  final DSAuthProvider _provider;

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
