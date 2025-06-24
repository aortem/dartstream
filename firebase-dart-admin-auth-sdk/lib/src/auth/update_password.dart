import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';

/// Service to update the user's password in Firebase Authentication.
class UpdatePassword {
  ///[auth] The instance of FirebaseAuth used to perform authentication actions.
  final FirebaseAuth auth;

  /// Constructor to initialize the [UpdatePassword] service.
  UpdatePassword({required this.auth});

  /// Updates the password for a Firebase user.
  ///
  /// This method takes the user's [newPassword] and [idToken] (obtained during sign-in)
  /// and makes a request to Firebase to update the password.
  ///
  /// Parameters:
  /// - [newPassword]: The new password that the user wants to set.
  /// - [idToken]: The Firebase ID token of the user. It is required to verify the user's identity.
  ///
  /// Returns:
  /// - A [User] object that represents the updated user details after the password change.
  ///
  /// Throws:
  /// - [FirebaseAuthException] if the request to update the password fails.
  Future<User> updatePassword(String newPassword, String? idToken) async {
    try {
      // Validate the parameters: ensure newPassword is not empty and idToken is not null.
      assert(newPassword.isNotEmpty, 'New password cannot be empty');
      assert(idToken != null, 'Id token cannot be null');

      // Perform the request to Firebase to update the user's password.
      final response = await auth.performRequest('update', {
        "idToken": idToken, // The Firebase ID token of the user.
        "password": newPassword, // The new password to set.
        "returnSecureToken":
            true, // Return a secure token after the password change.
      });

      // Parse the response to get the updated user object.
      User user = User.fromJson(response.body);

      // Update the current user in the authentication system.
      auth.updateCurrentUser(user);

      // Return the updated user object.
      return user;
    } catch (e) {
      // Handle errors during the request.
      print('Update password action failed: $e');
      throw FirebaseAuthException(
        code: 'update-password', // Custom error code for this action
        message: 'Failed to update password', // Error message
      );
    }
  }
}
