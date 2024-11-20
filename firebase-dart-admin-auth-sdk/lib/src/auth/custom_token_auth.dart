import 'dart:developer';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';

/// Service for signing in using a custom token in Firebase Authentication.
///
/// This class facilitates custom token authentication, allowing users
/// to sign in by providing a secure, pre-generated token.
class CustomTokenAuth {
  /// The [FirebaseAuth] instance for handling authentication requests.
  final FirebaseAuth auth;

  /// Constructs a [CustomTokenAuth] service with the given [FirebaseAuth] instance.
  ///
  /// Parameters:
  /// - [auth]: The [FirebaseAuth] instance that handles authentication requests.
  CustomTokenAuth(this.auth);

  /// Signs in a user with a custom token and updates the current user in the [FirebaseAuth] instance.
  ///
  /// Parameters:
  /// - [token]: The custom token used for signing in the user.
  ///
  /// Returns a [Future] that resolves to a [UserCredential], representing the authenticated user’s credentials.
  ///
  /// This method performs the following actions:
  /// 1. Sends a request to sign in with the custom token.
  /// 2. Logs the response from the Firebase Authentication REST API.
  /// 3. Creates a [UserCredential] from the response and updates the current user.
  Future<UserCredential> signInWithCustomToken(String token) async {
    final response = await auth.performRequest('signInWithCustomToken', {
      'token': token,
      'returnSecureToken': true,
    });

    // Log the response body for debugging purposes.
    log(response.body.toString());

    // Parse the response to obtain the user credential.
    final userCredential = UserCredential.fromJson(response.body);

    // Update the current user in the FirebaseAuth instance.
    auth.updateCurrentUser(userCredential.user);

    return userCredential;
  }
}
