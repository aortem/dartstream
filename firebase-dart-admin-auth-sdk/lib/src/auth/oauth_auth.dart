import 'package:firebase_dart_admin_auth_sdk/src/auth/auth_base.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class OAuthAuth extends AuthBase {
  OAuthAuth(super.auth);

  Future<UserCredential> signInWithPopup(String providerId) async {
    final response = await auth.performRequest('signInWithIdp', {
      'providerId': providerId,
      'signInMethod': 'popup',
    });

    final userCredential = UserCredential.fromJson(response.body);
    auth.updateCurrentUser(userCredential.user);
    return userCredential;
  }
}
