import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class AppleSignInViewModel {
  final FirebaseAuth auth;

  AppleSignInViewModel({required this.auth});

  Future<UserCredential> signInWithApple(
    String idToken, {
    String? nonce,
  }) async {
    if (idToken.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-id-token',
        message: 'Apple ID Token must not be empty',
      );
    }

    return await auth.signInWithApple(idToken, nonce: nonce);
  }
}
