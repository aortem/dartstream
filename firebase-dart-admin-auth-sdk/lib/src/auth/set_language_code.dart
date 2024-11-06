import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';

/// Service to set the language code for a Firebase user.
///
/// This class handles the process of setting the language code for a user
/// in Firebase Authentication, allowing the user to update their preferred
/// language for communication.
class SetLanguageCode {
  /// [auth] The instance of FirebaseAuth used to perform authentication actions.
  final FirebaseAuth auth;

  /// Constructor to initialize the [SetLanguageCode] service.
  SetLanguageCode({required this.auth});

  /// Sets the language code for the user.
  ///
  /// This method takes the user's [idToken] (obtained during sign-in)
  /// and the [languageCode] (which corresponds to the preferred language)
  /// and makes a request to Firebase to update the user's language code.
  ///
  /// Parameters:
  /// - [idToken]: The Firebase ID token of the user. It is required to verify the user's identity.
  /// - [languageCode]: The language code (such as 'en' for English, 'es' for Spanish).
  ///
  /// Returns:
  /// - A [User] object that represents the updated user details after the change.
  ///
  /// Throws:
  /// - [FirebaseAuthException] if the request to set the language code fails.
  Future<User> setLanguageCode(String? idToken, String languageCode) async {
    try {
      // Validate the parameters: make sure the idToken is not null
      // and the languageCode is not empty.
      assert(idToken != null, 'Id token cannot be null');
      assert(languageCode.isNotEmpty, 'Language code cannot be empty');

      // Perform the request to Firebase to update the language code for the user
      final response = await auth.performRequest(
        'update', // Firebase endpoint for updating user details
        {
          "idToken": idToken, // The Firebase ID token of the user
          "languageCode": languageCode, // The new language code to be set
        },
      );

      // Parse the response to get the updated user object
      User user = User.fromJson(response.body);

      // Update the current user with the new language code setting
      auth.updateCurrentUser(user);

      // Return the updated user object
      return user;
    } catch (e) {
      // Handle any errors during the request
      print('Set language code action failed: $e');
      throw FirebaseAuthException(
        code: 'set-language-code', // Custom error code for this action
        message: 'Failed to set language code', // Error message
      );
    }
  }
}
