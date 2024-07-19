import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';

class ApplyActionCode {
  final FirebaseAuth auth;

  ApplyActionCode(this.auth);

  Future<UserCredential> applyActionCode(String actionCode) async {

    try {
          final response = await auth.performRequest(
      'update',
      {
        'oobCode': actionCode,
      },
    );

    final userCredential = UserCredential.fromJson(response);
    auth.updateCurrentUser(userCredential.user);
    return userCredential;
    } catch (e) {
          print('Apply action code failed: $e');
      throw FirebaseAuthException(
        code: 'apply-action-code-error',
        message: 'Failed to apply action code.',
      );
    }

  }
}
