import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';

class UpdatePassword {
  final FirebaseAuth auth;

  UpdatePassword({required this.auth});

  Future<User> updatePassword(
    String newPassowrd,
    String? idToken,
  ) async {
    try {
      assert(newPassowrd.isNotEmpty, 'New password cannot be empty');
      assert(idToken != null, 'Id token cannot be null');
      final response = await auth.performRequest('update', {
        "idToken": idToken,
        "password": newPassowrd,
        "returnSecureToken": true
      });

      User user = User.fromJson(response);
      auth.updateCurrentUser(user);
      return user;
    } catch (e) {
      print('Update password action failed: $e');
      throw FirebaseAuthException(
        code: 'update-password',
        message: 'Failed to update password',
      );
    }
  }
}
