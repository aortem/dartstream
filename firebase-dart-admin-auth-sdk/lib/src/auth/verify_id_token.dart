import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/http_response.dart';

class VerifyIdTokenService {
  final FirebaseAuth auth;

  VerifyIdTokenService({required this.auth});

  Future<Map<String, dynamic>> verifyIdToken(String idToken) async {
    try {
      // Basic validation
      if (idToken.isEmpty || !_isValidJWT(idToken)) {
        throw FirebaseAuthException(
          code: 'invalid-id-token',
          message: 'The provided ID token is invalid',
        );
      }

      // Call Firebase Auth API to verify token
      final response = await auth.performRequest(
        'accounts:lookup',
        {'idToken': idToken},
      );

      // Process the verified token data
      final Map<String, dynamic> responseData = response.body;
      if (responseData['users'] == null || responseData['users'].isEmpty) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'No user found for the provided ID token',
        );
      }

      // Extract and normalize user data
      final userData = responseData['users'][0];
      return {
        'localId': userData['localId'] ?? '',
        'email': userData['email'] ?? '',
        'emailVerified': userData['emailVerified'] ?? false,
        'displayName': userData['displayName'] ?? '',
        'photoUrl': userData['photoUrl'] ?? '',
        'phoneNumber': userData['phoneNumber'] ?? '',
        'createdAt': userData['createdAt'] ?? '',
        'lastLoginAt': userData['lastLoginAt'] ?? '',
        'lastRefreshAt': userData['lastRefreshAt'] ?? '',
        'validSince': userData['validSince'] ?? '',
        'providerUserInfo':
            List<Map<String, dynamic>>.from(userData['providerUserInfo'] ?? []),
        'disabled': userData['disabled'] ?? false,
      };
    } catch (e) {
      if (e is FirebaseAuthException) {
        rethrow;
      }
      throw FirebaseAuthException(
        code: 'token-verification-failed',
        message: 'Failed to verify ID token: ${e.toString()}',
      );
    }
  }

  bool _isValidJWT(String token) {
    if (token.isEmpty) return false;

    final parts = token.split('.');
    if (parts.length != 3) return false;

    try {
      // Verify header and payload are valid base64
      for (var i = 0; i < 2; i++) {
        base64Url.decode(base64Url.normalize(parts[i]));
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
