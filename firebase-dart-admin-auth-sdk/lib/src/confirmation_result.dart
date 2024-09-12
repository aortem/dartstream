import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class ConfirmationResult {
  final FirebaseAuth auth;
  final String verificationId;
  final String phoneNumber;

  ConfirmationResult({
    required this.auth,
    required this.verificationId,
    required this.phoneNumber,
  });

  Future<UserCredential> confirm(String verificationCode) async {
    final response = await auth.performRequest('signInWithPhoneNumber', {
      'sessionInfo': verificationId,
      'code': verificationCode,
      'key': auth.apiKey,
    });

    if (response.body['idToken'] == null) {
      throw FirebaseAuthException(
        code: 'invalid-verification-code',
        message: 'The SMS verification code is invalid.',
      );
    }

    final userCredential = UserCredential.fromJson(response.body);
    auth.updateCurrentUser(userCredential.user);
    return userCredential;
  }
}
