import 'package:firebase_dart_admin_auth_sdk/src/user.dart';
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

      final response = await auth.performRequest('update', {
        'idToken': idToken,
        'email': email,
        'returnSecureToken': false,
      });

      User user = User.fromJson(response.body);

      auth.updateCurrentUser(user);

      await auth.performRequest(
        'sendOobCode',
        {
          "requestType": "VERIFY_EMAIL",
          "idToken": auth.currentUser?.idToken,
          "email": email,
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
