import 'dart:developer';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';

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
    try {
      log('Signing in with custom token');

      final response = await auth.performRequest('signInWithCustomToken', {
        'token': token,
        'returnSecureToken': true,
      });

      if (response.statusCode != 200) {
        throw FirebaseAuthException(
          code: 'invalid-custom-token',
          message: 'The custom token format is incorrect or expired',
        );
      }

      final userData = response.body;

      // Create user instance from response data
      final user = User(
        uid: userData['localId'] ?? '',
        email: userData['email'],
        emailVerified: userData['emailVerified'] ?? false,
        displayName: userData['displayName'],
        photoURL: userData['photoUrl'],
        phoneNumber: userData['phoneNumber'],
        disabled: userData['disabled'] ?? false,
        idToken: userData['idToken'],
        refreshToken: userData['refreshToken'],
      );

      // Create and return UserCredential
      final userCredential = UserCredential(
        user: user,
        operationType: 'signIn',
      );

      // Update current auth state
      auth.updateCurrentUser(user);

      log('Successfully signed in with custom token');
      return userCredential;
    } catch (e) {
      log('Custom token sign in error: $e');
      throw FirebaseAuthException(
        code: 'custom-token-error',
        message: 'Failed to sign in with custom token: ${e.toString()}',
      );
    }
  }
}
