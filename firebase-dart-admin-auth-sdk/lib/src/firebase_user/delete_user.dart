import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

import 'dart:convert';

/// A service class responsible for deleting a user from Firebase Authentication.
class FirebaseDeleteUser {
  /// The FirebaseAuth instance used for interacting with Firebase Authentication.
  final FirebaseAuth auth;

  /// Constructor to initialize the [FirebaseDeleteUser] with a [FirebaseAuth] instance.
  ///
  /// This constructor requires a [FirebaseAuth] instance to interact with Firebase Authentication
  /// and perform actions like user deletion.

  FirebaseDeleteUser({required this.auth});

  /// Deletes a user from Firebase Authentication.
  ///
  /// This method sends a request to the Firebase Authentication API to delete a user based on their
  /// Firebase ID token and UID. It uses the [idToken] and [uid] to authenticate the request and identify
  /// the user to be deleted.
  ///
  /// - [idToken] The Firebase ID token of the user to be deleted. This token is used for authenticating
  ///   the request and ensuring that the caller has permission to delete the user.
  /// - [uid] The UID (unique identifier) of the user to be deleted. This is used to identify the user
  ///   within Firebase Authentication.
  ///
  /// The method sends a POST request to the Firebase Authentication API, and if the request is successful,
  /// the user will be deleted. If the deletion fails or an error occurs, appropriate error messages are logged.

  // Method to delete a user based on their ID token and UID
  Future<String?> deleteUser(String idToken, String uid) async {
    // Construct the URL for the Firebase Authentication API endpoint to delete a user

    final url = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:delete?key=${auth.apiKey}',
    );

    try {
      // Send an HTTP POST request to Firebase Authentication to delete the user
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        }, // Set content type to JSON
        body: jsonEncode({
          'idToken': idToken, // The Firebase ID token of the user
          'localId': uid, // The UID of the user to be deleted
        }),
      );

      // Check if the HTTP request was successful (status code 200)
      if (response.statusCode == 200) {
        print('Successfully deleted user with UID: $uid');

        // Optionally, set the current user to null in the FirebaseApp instance to clear session
        FirebaseApp.instance.setCurrentUser(null);
        return uid;
      } else {
        return response.body;
        // If the request failed, log the error message and response body
      }
    } catch (e) {
      // Catch and log any errors that occurred during the HTTP request
      return "Error: $e";
    }
  }
}
