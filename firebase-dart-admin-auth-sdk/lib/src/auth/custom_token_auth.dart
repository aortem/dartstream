import 'dart:developer';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';

class CustomTokenAuth {
  final FirebaseAuth auth;

  CustomTokenAuth(this.auth);

  Future<UserCredential> signInWithCustomToken(String token) async {
    try {
      log('Signing in with custom token');

      final response = await auth.performRequest(
        'signInWithCustomToken',
        {
          'token': token,
          'returnSecureToken': true,
        },
      );

      if (response.statusCode != 200 || response.body == null) {
        throw FirebaseAuthException(
            code: 'invalid-custom-token',
            message: 'The custom token format is incorrect or expired');
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
          message: 'Failed to sign in with custom token: ${e.toString()}');
    }
  }
}
