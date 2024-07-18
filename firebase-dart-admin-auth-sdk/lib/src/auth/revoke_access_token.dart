import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

class RevokeAccessTokenService {
  final FirebaseAuth _auth;

  RevokeAccessTokenService({required FirebaseAuth auth}) : _auth = auth;

  Future<void> revokeToken(String idToken) async {
    await _auth.performRequest('revokeToken', {
      'token': idToken,
    });
  }
}
