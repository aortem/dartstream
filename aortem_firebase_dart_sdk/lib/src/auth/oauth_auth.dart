import 'package:firebase_dart_admin_auth_sdk/src/auth/auth_base.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';

class OAuthAuth extends AuthBase {
  OAuthAuth(super.auth);

  Future<UserCredential> signInWithPopup(String providerId) async {
    // This is a placeholder implementation. In a real-world scenario,
    // you would need to implement the OAuth flow, which typically involves
    // opening a popup window or redirecting the user to the provider's login page.
    final response = await auth.performRequest('signInWithIdp', {
      'providerId': providerId,
      'signInMethod': 'popup',
    });

    final userCredential = UserCredential.fromJson(response);
    auth.updateCurrentUser(userCredential.user);
    return userCredential;
  }
}
