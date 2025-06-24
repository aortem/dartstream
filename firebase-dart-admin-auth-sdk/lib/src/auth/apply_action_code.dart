import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

/// Provides functionality to apply action codes (such as email verification
/// or password reset) within Firebase.
class ApplyActionCode {
  /// The [FirebaseAuth] instance used to interact with Firebase for
  /// applying action codes.
  final FirebaseAuth auth;

  /// Constructs an instance of [ApplyActionCode].
  ///
  /// Parameters:
  /// - [auth]: The [FirebaseAuth] instance to be used for performing requests.
  ApplyActionCode(this.auth);

  /// Applies an action code in Firebase, such as email verification or
  /// password reset.
  ///
  /// Parameters:
  /// - [actionCode]: The one-time code to be applied, as provided by Firebase.
  ///
  /// Returns `true` if the action code was applied successfully, otherwise
  /// throws a [FirebaseAuthException].
  ///
  /// Throws:
  /// - [FirebaseAuthException] if the action code application fails.
  Future<bool> applyActionCode(String actionCode) async {
    try {
      await auth.performRequest('update', {'oobCode': actionCode});
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
