import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class RevokeAccessTokenService {
  final FirebaseAuth _auth;

  RevokeAccessTokenService({required FirebaseAuth auth}) : _auth = auth;

  Future<void> revokeToken(String idToken) async {
    try {
      await _auth.performRequest('revokeToken', {
        'token': idToken,
      });
    } catch (e) {
      throw FirebaseAuthException(
        code: 'revoke-token-error',
        message: 'Failed to revoke token: ${e.toString()}',
      );
    }
  }
}
