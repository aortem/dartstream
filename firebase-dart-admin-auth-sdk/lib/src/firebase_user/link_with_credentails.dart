import 'dart:convert';
import 'dart:developer';
import 'package:ds_standard_features/ds_standard_features.dart' as http;
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

/// A service that links a Firebase user with an external provider's credential.
///
/// This class facilitates linking a user's authentication credentials (such as a third-party provider)
/// to their existing Firebase account. The user is authenticated with an `idToken` and a `providerId`
/// (which represents the external provider). The method then sends a request to Firebase Authentication
/// to link the credentials with the user's Firebase account.
class LinkWithCredientialClass {
  /// The [FirebaseAuth] instance used for performing Firebase authentication actions.
  final FirebaseAuth auth;

  /// Constructs an instance of [LinkWithCredientialClass].
  ///
  /// Parameters:
  /// - [auth]: The [FirebaseAuth] instance used for interacting with Firebase authentication services.
  LinkWithCredientialClass({required this.auth});

  /// Links the provided credentials with the user's Firebase account.
  ///
  /// This method sends a request to Firebase's Identity Toolkit API to link an external provider's
  /// credentials (such as a third-party OAuth token) with the current Firebase user's account.
  /// If successful, it updates the current user and returns a [UserCredential].
  ///
  /// Parameters:
  /// - [redirectUri]: The URI to which the response from the provider will be redirected.
  /// - [idToken]: The Firebase ID token of the current user.
  /// - [providerId]: The provider ID of the external authentication provider (e.g., Google, Facebook).
  ///
  /// Returns:
  /// - A [UserCredential] object that contains the updated user data if the request is successful.
  /// - `null` if the request fails or an error occurs.
  Future<UserCredential?> linkWithCrediential(
    String redirectUri,
    String idToken,
    String providerId,
  ) async {
    try {
      // Log the input parameters for debugging purposes
      log("ID Token: $idToken");
      log("Provider ID: $providerId");

      // Construct the URL for Firebase Authentication API to update user credentials
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:update?key=${auth.apiKey}';

      // Make the HTTP request to link the credentials with Firebase user account
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'postBody':
              'access_token=$idToken&providerId=$providerId', // The credentials to link
          'requestUri': redirectUri, // The URI for the response
          'returnSecureToken': true, // Request a new secure token
        }),
      );

      // Log the response status code for debugging purposes
      log('responseData: ${response.statusCode}');

      // Check if the response is successful (HTTP 200)
      if (response.statusCode == 200) {
        // Parse the response data to extract the user credential
        final responseData = jsonDecode(response.body);
        final userCredential = UserCredential.fromJson(responseData);

        // Update the current user in the authentication service
        auth.updateCurrentUser(userCredential.user);

        // Log the updated user information
        log("current user data ${userCredential.user.idToken}");

        // Set the current user in the Firebase app instance
        FirebaseApp.instance.setCurrentUser(userCredential.user);

        // Log the access token
        log('Access Token: ${responseData['idToken']}');

        // Return the updated user credential
        return userCredential;
      } else {
        // Log failure response if the status code is not 200
        log('Failed to sign in: ${response.statusCode}');
        log('Response: ${response.body}');
        return null;
      }
    } catch (error) {
      // Catch and log any errors that occur during the process
      log('Error occurred during sign in: $error');
    }

    // Return null if the request failed or if an error occurred
    return null;
  }
}
