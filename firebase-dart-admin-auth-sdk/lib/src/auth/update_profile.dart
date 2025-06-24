import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';

/// Service to update the user's profile information (display name and photo URL).
class UpdateProfile {
  /// [auth] The instance of FirebaseAuth used to perform authentication actions.
  final FirebaseAuth auth;

  /// Constructor to initialize the [UpdateProfile] service.
  UpdateProfile(this.auth);

  /// Updates the display name and photo URL for a Firebase user.
  ///
  /// This method takes the user's [displayName], [displayImage] (photo URL), and [idToken]
  /// (obtained during sign-in) and makes a request to Firebase to update the profile.
  ///
  /// Parameters:
  /// - [displayName]: The new display name to set for the user.
  /// - [displayImage]: The URL of the new photo to set for the user.
  /// - [idToken]: The Firebase ID token of the user. It is required to verify the user's identity.
  ///
  /// Returns:
  /// - A [User] object that represents the updated user details after the profile update.
  ///
  /// Throws:
  /// - [FirebaseAuthException] if the request to update the profile fails.
  Future<User> updateProfile(
    String displayName,
    String displayImage,
    String? idToken,
  ) async {
    try {
      // Validate the parameters: ensure idToken is not null.
      assert(idToken != null, 'Id token cannot be null');

      // Perform the request to Firebase to update the user's profile.
      final response = await auth.performRequest(
        'update', // Firebase endpoint to update user data.
        {
          "idToken": idToken, // The Firebase ID token of the user.
          "displayName": displayName, // The new display name to set.
          "photoUrl": displayImage, // The new photo URL to set.
          "returnSecureToken": true, // Return a secure token after the update.
        },
      );

      // Parse the response to get the updated user object.
      User user = User.fromJson(response.body);

      // Update the current user in the authentication system.
      auth.updateCurrentUser(user);

      // Return the updated user object.
      return user;
    } catch (e) {
      // Handle errors during the request.
      print('Update profile failed: $e');
      throw FirebaseAuthException(
        code: 'update-profile', // Custom error code for this action.
        message: 'Failed to update user.', // Error message.
      );
    }
  }
}
