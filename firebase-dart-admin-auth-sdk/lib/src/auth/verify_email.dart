import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

class VerifyEmail {
  final FirebaseAuth auth;

  VerifyEmail(this.auth);

  Future<bool> verifyEmail(
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
      return true;
    } catch (e) {
      print('Verify email failed: $e');
      throw FirebaseAuthException(
        code: 'Verify-email',
        message: 'Failed to verify email.',
      );
    }
  }
}
