import 'dart:developer';

import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class UpdateCurrentUser {
  final FirebaseAuth auth;

  UpdateCurrentUser({required this.auth});

  Future<void> updateCurrentUser(String userId, String IdToken,
      [Map<String, dynamic>? userData]) async {
    try {
      // Construct the request body
      final Map<String, dynamic> requestBody = {
        'idToken': IdToken,
        'localId': userId,
        'returnSecureToken': true,
      };
      log("user data is $userData");
      // Add optional user data fields if provided
      if (userData != null) {
        requestBody.addAll(userData);
      }

      // Perform the request
      final url = 'update';

      final response = await auth.performRequest(url, requestBody);

      if (response.statusCode == 200) {
        log("User is Updated");
      } else {
        log('update failed: ${response.body}');
        throw FirebaseAuthException(
          code: 'update-current-user-error',
          message: 'Failed to update current user. ${response.body}',
        );
      }
    } catch (e) {
      print('Update current user failed: $e');
      throw FirebaseAuthException(
        code: 'update-current-user-error',
        message: 'Failed to update current user.',
      );
    }
  }
}
