import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

class ApplyActionCode {
  final FirebaseAuth auth;

  ApplyActionCode(this.auth);

  Future<bool> applyActionCode(String actionCode) async {
    try {
      await auth.performRequest(
        'update',
        {
          'oobCode': actionCode,
        },
      );

      return true;
    } catch (e) {
      print('Apply action code failed: $e');
      throw FirebaseAuthException(
        code: 'apply-action-code-error',
        message: 'Failed to apply action code.',
      );
    }
  }
}
