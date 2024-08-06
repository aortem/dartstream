import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

class SendEmailVerificationCode {
  final FirebaseAuth auth;

  SendEmailVerificationCode({required this.auth});

  Future<void> sendEmailVerificationCode(
    String? idToken,
  ) async {
    try {
      assert(idToken != null, 'Id token cannot be null');
      await auth.performRequest(
        'sendOobCode',
        {
          "requestType": "VERIFY_EMAIL",
          "idToken": idToken,
        },
      );
    } catch (e) {
      print('Send email verification code failed: $e');
      throw FirebaseAuthException(
        code: 'send-email-verification-code',
        message: 'Failed to send email verification code',
      );
    }
  }
}
