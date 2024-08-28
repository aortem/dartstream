import 'package:firebase_dart_admin_auth_sdk/src/utils.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

class VerifyBeforeEmailUpdate {
  final FirebaseAuth auth;

  VerifyBeforeEmailUpdate(this.auth);

  Future<bool> verifyBeforeEmailUpdate(
    String? idToken,
    String email, {
    ActionCodeSettings? action,
  }) async {
    try {
      assert(idToken != null, 'Id token cannot be null');

      await auth.performRequest(
        'sendOobCode',
        {
          "requestType": "VERIFY_AND_CHANGE_EMAIL",
          "idToken": auth.currentUser?.idToken,
          "newEmail": email,
          if (action != null) "actionCodeSettings": action.toMap(),
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
