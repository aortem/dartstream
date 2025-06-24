import 'dart:developer';
import '../../firebase_dart_admin_auth_sdk.dart';

/// A service that handles anonymous sign-in for Firebase Authentication.
///
/// This class is responsible for signing in a user anonymously using Firebase Authentication.
/// Anonymous sign-in is useful when you want to allow users to interact with your app
/// without requiring them to sign up or log in with a credential like email/password.
class FirebaseSignInAnonymously {
  /// The [FirebaseAuth] instance used for authentication actions.
  final FirebaseAuth auth;

  /// Constructs an instance of [FirebaseSignInAnonymously].
  ///
  /// Parameters:
  /// - [auth]: The [FirebaseAuth] instance used for performing Firebase Authentication requests.
  FirebaseSignInAnonymously(this.auth);

  /// Signs in a user anonymously in Firebase Authentication.
  ///
  /// This method sends a request to Firebase Authentication to create an anonymous
  /// user account and return the user credentials.
  ///
  /// It performs the following steps:
  /// 1. Sends a request to the Firebase Authentication API to sign up the user anonymously.
  /// 2. If the sign-in is successful (status code 200), it updates the current user data and
  ///    logs the result, including the user's ID token.
  /// 3. If the sign-in fails, it logs the error response from Firebase and returns `null`.
  ///
  /// Returns:
  /// - A [UserCredential] object if the sign-in is successful.
  /// - `null` if the sign-in fails.
  Future<UserCredential?> signInAnonymously() async {
    try {
      // Send the request to Firebase Authentication to sign up the user anonymously
      final response = await auth.performRequest('signUp', {
        // 'idToken': idToken,  // No idToken required for anonymous sign-in
        'returnSecureToken':
            true, // Request to return a secure token for the anonymous user
      });

      // Check if the sign-in request was successful (status code 200)
      if (response.statusCode == 200) {
        // Parse the response body to obtain the user credentials
        final userCredential = UserCredential.fromJson(response.body);

        // Update the current user with the newly signed-in user data
        auth.updateCurrentUser(userCredential.user);

        // Log the user's ID token for debugging purposes
        log("Current user data: ${userCredential.user.idToken}");

        // Set the user as the current user in the FirebaseApp instance
        FirebaseApp.instance.setCurrentUser(userCredential.user);

        // Return the user credential with the authenticated user's data
        return userCredential;
      } else {
        // Log an error if the sign-in request failed
        log('Error signing in: ${response.body}');
        return null;
      }
    } catch (e) {
      // Catch any unexpected errors during the sign-in process
      log('Exception occurred during anonymous sign-in: $e');
      return null;
    }
  }
}
