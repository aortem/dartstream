import 'dart:developer';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

/// A service to set or retrieve the language code used by a user's device.
///
/// This service allows you to determine the language setting of a user's device by checking
/// the `languageCode` property associated with the user account. It can be used to fetch the
/// language code from Firebase Authentication and possibly set it based on the user's device language.
class UseDeviceLanguageService {
  /// The [FirebaseAuth] instance used for performing authentication actions.
  final FirebaseAuth auth;

  /// Constructs an instance of [UseDeviceLanguageService].
  ///
  /// Parameters:
  /// - [auth]: The [FirebaseAuth] instance that handles Firebase Authentication requests.
  UseDeviceLanguageService({required this.auth});

  /// Retrieves the language code set for the user's device.
  ///
  /// This method sends a request to Firebase's Authentication API to look up the user's information,
  /// including their device language. It returns the language code associated with the user's account.
  ///
  /// Parameters:
  /// - [userId]: The ID token or UID of the user whose language setting is being queried.
  /// - [languageCode]: A language code (e.g., 'en', 'fr', 'es') to potentially update or use for device-specific operations.
  ///
  /// Returns:
  /// - A [String] representing the user's language code, or `null` if the user is not found or if an error occurs.
  ///
  /// Throws:
  /// - [FirebaseAuthException] if the operation fails (e.g., network issue or incorrect response).
  Future<String?> useDeviceLanguage(String userId, String languageCode) async {
    try {
      // The URL for the Firebase Authentication API endpoint to retrieve user info.
      final url = 'lookup';

      // The body of the request containing the user's ID token (or UID).
      final body = {
        'idToken': userId, // The ID token of the user to look up.
      };

      // Perform the request to Firebase Authentication to get user information.
      final response = await auth.performRequest(url, body);

      // Check if the response was successful (status code 200).
      if (response.statusCode == 200) {
        // Parse the response body to extract the user's language code.
        final Map<String, dynamic> responseBody = response.body;

        // Get the list of users returned in the response.
        final List users = responseBody['users'] ?? [];

        // If users are found, retrieve the language code.
        if (users.isNotEmpty) {
          final String? languageCode = users[0]['languageCode'];

          // Log the language code retrieval process.
          log("No device language is set.");

          // Return the language code, which might be set for the user.
          return languageCode;
        } else {
          // If no user is found in the response, print an error message.
          print('User not found.');
          return null;
        }
      } else {
        // Log the response body if the status code is not 200 (indicating failure).
        print('Update failed: ${response.body}');
      }
    } catch (e) {
      // Handle any errors that occur during the request process.
      print('Use device language failed: $e');

      // Throw a FirebaseAuthException if the operation fails.
      throw FirebaseAuthException(
        code: 'use-device-language-error', // Custom error code for this action.
        message:
            'Failed to set device language.', // Error message explaining the failure.
      );
    }

    // Return null if the language code could not be determined or an error occurred.
    return null;
  }
}
