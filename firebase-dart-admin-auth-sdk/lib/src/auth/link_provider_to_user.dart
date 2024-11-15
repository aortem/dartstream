import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

/// Service to link a provider (such as Google or Facebook) to an existing Firebase user.
///
/// This class handles the process of associating an external provider's credentials (like a
/// Google or Facebook token) with the current Firebase user.
class LinkProviderToUser {
  /// [auth] The instance of FirebaseAuth used to perform authentication actions.
  final FirebaseAuth auth;

  /// Constructor to initialize the [LinkProviderToUser] service.
  LinkProviderToUser({required this.auth});

  /// Links an external authentication provider to the current Firebase user.
  ///
  /// This method takes the current user's [idToken], the [providerId] of the external
  /// authentication provider, and the [providerIdToken] (such as a Google or Facebook token).
  /// It then sends a request to Firebase to link the external provider with the existing user.
  ///
  /// Parameters:
  /// - [idToken]: The Firebase ID token of the authenticated user to whom the provider
  ///   will be linked.
  /// - [providerId]: The ID of the external authentication provider (e.g., 'google.com').
  /// - [providerIdToken]: The authentication token from the external provider (e.g., the
  ///   Google or Facebook access token).
  ///
  /// Returns:
  /// - A [Future] that resolves to a [bool] indicating whether the provider was successfully
  ///   linked to the user.
  ///
  /// Throws:
  /// - [FirebaseAuthException] if there is an error while linking the provider or if any
  ///   parameter is invalid.
  Future<bool> linkProviderToUser(
    String? idToken,
    String providerId,
    String providerIdToken,
  ) async {
    try {
      // Validate inputs to ensure they are not null or empty
      assert(idToken != null, 'Id token cannot be null');
      assert(providerId.isNotEmpty, 'Provider Id cannot be empty');
      assert(providerIdToken.isNotEmpty, 'Provider Id Token cannot be empty');

      // Perform the request to Firebase to link the provider to the user
      await auth.performRequest(
        'update', // Endpoint to update the user with new provider info
        {
          "idToken": idToken, // The user's current Firebase ID token
          "providerId":
              providerId, // The external provider ID (e.g., 'google.com')
          "postBody":
              'id_token=$providerIdToken&providerId=$providerId', // The provider's token and ID
          "returnSecureToken": true, // Ensure a secure token is returned
        },
      );

      // Return true if the request was successful and provider was linked
      return true;
    } catch (e) {
      // Handle errors and throw a FirebaseAuthException if the provider linking fails
      print('Link additional provider to user failed: $e');
      throw FirebaseAuthException(
        code: 'link-additional-provider',
        message: 'Failed to link additional provider',
      );
    }
  }
}
