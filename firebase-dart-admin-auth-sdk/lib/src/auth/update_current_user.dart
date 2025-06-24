import 'dart:developer';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

/// A service to update the details of the current user in Firebase Authentication.
///
/// This service allows you to update the user profile, including fields such as email, display name,
/// photo URL, etc., by sending a request to Firebase Authentication's `update` endpoint.
/// You can optionally include additional user data fields to update.
class UpdateCurrentUser {
  /// The [FirebaseAuth] instance used to perform authentication actions.
  final FirebaseAuth auth;

  /// Constructs an instance of [UpdateCurrentUser].
  ///
  /// Parameters:
  /// - [auth]: The [FirebaseAuth] instance used for performing Firebase Authentication requests.
  UpdateCurrentUser({required this.auth});

  /// Updates the current user's profile data in Firebase Authentication.
  ///
  /// This method allows updating a user's profile information in Firebase Authentication. You can
  /// pass optional user data fields (e.g., email, display name, etc.) in the [userData] parameter.
  ///
  /// Parameters:
  /// - [userId]: The Firebase user ID (UID) of the user whose data you want to update.
  /// - [idToken]: The Firebase ID token of the user (to verify the user's identity).
  /// - [userData]: An optional [Map] containing additional user profile fields to update (e.g.,
  ///   `{"displayName": "John Doe"}`).
  ///
  /// Returns:
  /// - This method does not return a value, but logs the result of the update operation.
  ///
  /// Throws:
  /// - [FirebaseAuthException] if the update fails, providing a code and message to describe the error.
  Future<void> updateCurrentUser(
    String userId,
    String idToken, [
    Map<String, dynamic>? userData,
  ]) async {
    try {
      // Construct the request body with the user ID token and ID
      final Map<String, dynamic> requestBody = {
        'idToken': idToken, // The ID token used to authenticate the user
        'localId': userId, // The UID of the user whose profile is being updated
        'returnSecureToken':
            true, // Flag to return a new secure token after update
      };

      // If user data is provided, include it in the request body
      log("User data to update: $userData");
      if (userData != null) {
        requestBody.addAll(
          userData,
        ); // Merge the optional user data into the request body
      }

      // The Firebase Authentication endpoint to update user details
      final url = 'update';

      // Perform the request to update the user in Firebase Authentication
      final response = await auth.performRequest(url, requestBody);

      // Check if the update was successful (status code 200)
      if (response.statusCode == 200) {
        log("User updated successfully.");
      } else {
        // If the update fails, log the error response and throw an exception
        log('Update failed: ${response.body}');
        throw FirebaseAuthException(
          code:
              'update-current-user-error', // Custom error code for update failure
          message:
              'Failed to update current user. ${response.body}', // Error message
        );
      }
    } catch (e) {
      // Log the error if an exception occurs during the request
      print('Update current user failed: $e');

      // Throw a FirebaseAuthException if the update operation fails
      throw FirebaseAuthException(
        code: 'update-current-user-error', // Custom error code
        message: 'Failed to update current user.', // Error message
      );
    }
  }
}
