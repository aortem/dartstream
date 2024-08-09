import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class PasswordResetEmailService {
  final FirebaseAuth _auth;

  PasswordResetEmailService({required FirebaseAuth auth}) : _auth = auth;

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.performRequest('sendOobCode', {
        'requestType': 'PASSWORD_RESET',
        'email': email,
      });
    } catch (e) {
      throw FirebaseAuthException(
        code: 'password-reset-error',
        message: 'Failed to send password reset email: ${e.toString()}',
      );
    }
  }
}
