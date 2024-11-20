import 'package:firebase_dart_admin_auth_sdk/src/utils.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

/// Service to send an email verification code for changing the user's email.
class VerifyBeforeEmailUpdate {
  /// [auth] The instance of FirebaseAuth used to perform authentication actions.
  final FirebaseAuth auth;

  /// Constructor to initialize the [VerifyBeforeEmailUpdate] service.
  VerifyBeforeEmailUpdate(this.auth);

  /// Sends a verification code to the user's email address to verify before updating it.
  ///
  /// This method sends a request to Firebase to initiate the email change process.
  /// The user must verify the new email before it can be updated.
  ///
  /// Parameters:
  /// - [idToken]: The Firebase ID token of the user. It is required to verify the user's identity.
  /// - [email]: The new email to set for the user.
  /// - [action]: Optional. An [ActionCodeSettings] object that provides additional settings
  ///   for the email verification action, such as URL and handle code in the app.
  ///
  /// Returns:
  /// - [bool]: A boolean indicating whether the request was successful.
  ///
  /// Throws:
  /// - [FirebaseAuthException] if the request to verify the email fails.
  Future<bool> verifyBeforeEmailUpdate(
    String? idToken,
    String email, {
    ActionCodeSettings? action,
  }) async {
    try {
      // Ensure the idToken is not null.
      assert(idToken != null, 'Id token cannot be null');

      // Perform the request to Firebase to verify the email address before updating.
      await auth.performRequest(
        'sendOobCode', // Firebase endpoint for sending an out-of-band (OOB) verification code.
        {
          "requestType":
              "VERIFY_AND_CHANGE_EMAIL", // Request type for email verification.
          "idToken": auth.currentUser?.idToken, // The user's Firebase ID token.
          "newEmail": email, // The new email to be verified.
          if (action != null)
            "actionCodeSettings": action.toMap(), // Optional action settings.
        },
      );
      // Return true if the request was successful.
      return true;
    } catch (e) {
      // Handle any errors and throw a FirebaseAuthException with an error code.
      print('Verify email failed: $e');
      throw FirebaseAuthException(
        code: 'Verify-email', // Custom error code for this action.
        message: 'Failed to verify email.', // Error message.
      );
    }
  }
}
