import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

/// Service to send an email verification code to the user.
///
/// This class handles the process of sending a verification email to a user
/// using Firebase Authentication by making a request to Firebase to send
/// an email verification code, usually after the user signs up or changes
/// their email.
class SendEmailVerificationCode {
  /// [auth] The instance of FirebaseAuth used to perform authentication actions.
  final FirebaseAuth auth;

  /// Constructor to initialize the [SendEmailVerificationCode] service.
  SendEmailVerificationCode({required this.auth});

  /// Sends an email verification code to the user.
  ///
  /// This method takes the user's [idToken] (obtained during the sign-in process)
  /// and sends a request to Firebase to trigger sending an email with a verification code.
  ///
  /// Parameters:
  /// - [idToken]: The Firebase ID token of the user. It is required to verify the user's identity.
  ///
  /// Throws:
  /// - [FirebaseAuthException] if the request to send the verification email fails.
  Future<void> sendEmailVerificationCode(String? idToken) async {
    try {
      // Validate that the idToken is not null
      assert(idToken != null, 'Id token cannot be null');

      // Perform the request to Firebase to send an email verification code
      await auth.performRequest(
        'sendOobCode', // Firebase endpoint for sending verification email
        {
          "requestType": "VERIFY_EMAIL", // Action type: send email verification
          "idToken": idToken, // The user's Firebase ID token
        },
      );
    } catch (e) {
      // Handle any errors during the process
      print('Send email verification code failed: $e');
      throw FirebaseAuthException(
        code: 'send-email-verification-code',
        message: 'Failed to send email verification code',
      );
    }
  }
}
