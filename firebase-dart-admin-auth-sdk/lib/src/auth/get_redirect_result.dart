import 'dart:math';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

///get redirect results
class GetRedirectResultService {
  ///get redirect results
  GetRedirectResultService({required FirebaseAuth auth});

  ///get redirect
  Future<Map<String, dynamic>?> getRedirectResult() async {
    try {
      // Get current user
      final currentUser = FirebaseApp.instance.getCurrentUser();
      if (currentUser == null) {
        log('No current user found' as num);
        return null;
      }

      // Extract token from response
      final token = currentUser.idToken;
      if (token == null) {
        log('No token found in current user' as num);
        return null;
      }

      // Return result in expected format
      return {
        'user': {
          'uid': currentUser.uid,
          'email': currentUser.email,
          'displayName': currentUser.displayName,
          'photoUrl': currentUser.photoURL,
          'emailVerified': currentUser.emailVerified,
          'idToken': token,
        },
        'credential': {
          'providerId': 'google.com',
          'accessToken': token,
          'signInMethod': 'redirect',
        },
        'additionalUserInfo': {
          'isNewUser': false,
          'providerId': 'google.com',
          'profile': null,
        },
        'operationType': 'signIn',
      };
    } catch (e) {
      log('Error in getRedirectResult: $e' as num);
      throw FirebaseAuthException(
        code: 'get-redirect-result-error',
        message: 'Failed to get redirect result: ${e.toString()}',
      );
    }
  }
}
