import 'dart:developer';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/http_response.dart';

class CustomTokenAuth {
  final FirebaseAuth auth;

  CustomTokenAuth(this.auth);

  Future<UserCredential> signInWithCustomToken(String token) async {
    try {
      log('Attempting to sign in with custom token');

      final response = await auth.performRequest(
        'signInWithCustomToken',
        {
          'token': token,
          'returnSecureToken': true,
        },
      );

      log('Custom token sign-in raw response: ${response.body}');

      // Prepare user data with proper null handling
      final responseData = response.body;

      // Create user data with required and optional fields
      final userData = {
        'uid': responseData['localId'] ??
            responseData['user_id'], // Try both possible field names
        'email': responseData['email'],
        'emailVerified': responseData['emailVerified'] ?? false,
        'displayName': responseData['displayName'],
        'photoURL': responseData['photoUrl'],
        'phoneNumber': responseData['phoneNumber'],
        'disabled': responseData['disabled'] ?? false,
        'createdAt': responseData['createdAt'],
        'lastLoginAt': responseData['lastLoginAt'],
        'idToken': responseData['idToken'],
        'refreshToken': responseData['refreshToken'],
      };

      log('Processed user data: $userData');

      // Create UserCredential with processed data
      final userCredential = UserCredential(
        user: User(
          uid: userData['uid'] as String,
          email: userData['email'] as String?,
          emailVerified: userData['emailVerified'] as bool? ?? false,
          displayName: userData['displayName'] as String?,
          photoURL: userData['photoURL'] as String?,
          phoneNumber: userData['phoneNumber'] as String?,
          disabled: userData['disabled'] as bool? ?? false,
          idToken: userData['idToken'] as String?,
          refreshToken: userData['refreshToken'] as String?,
        ),
        operationType: 'signIn',
        // providerId: 'custom',
      );

      // Update current user state
      auth.updateCurrentUser(userCredential.user);

      log('Successfully created user credential');
      return userCredential;
    } catch (e) {
      log('Error during custom token sign in: $e');
      throw FirebaseAuthException(
        code: 'custom-token-sign-in-error',
        message: 'Failed to sign in with custom token: ${e.toString()}',
      );
    }
  }

  Future<UserCredential> generateAndSignInWithCustomToken(String? uid) async {
    if (auth.serviceAccount == null) {
      throw FirebaseAuthException(
        code: 'missing-service-account',
        message:
            'Service Account configuration is required for token generation',
      );
    }

    if (auth.generateCustomToken == null) {
      throw FirebaseAuthException(
        code: 'missing-token-generator',
        message: 'Custom token generator is not configured',
      );
    }

    if (uid == null || uid.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-uid',
        message: 'User ID cannot be null or empty',
      );
    }

    try {
      log('Generating custom token for UID: $uid');

      // Generate token
      final token = await auth.generateCustomToken!.generateSignInJwt(
        auth.serviceAccount!,
        uid: uid,
      );

      if (token == null || token.isEmpty) {
        throw FirebaseAuthException(
          code: 'token-generation-failed',
          message: 'Failed to generate valid custom token',
        );
      }

      log('Successfully generated token, proceeding to sign in');

      // Use the token to sign in
      return await signInWithCustomToken(token);
    } catch (e) {
      log('Error generating and signing in with custom token: $e');
      throw FirebaseAuthException(
        code: 'custom-token-error',
        message:
            'Failed to generate and sign in with custom token: ${e.toString()}',
      );
    }
  }
}
