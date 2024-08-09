import 'dart:developer';

import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class UpdateCurrentUser {
  final FirebaseAuth auth;

  UpdateCurrentUser({required this.auth});

  Future<void> updateCurrentUser(String userId, String IdToken,
      [Map<String, dynamic>? userData]) async {
    try {
      final url = 'update';

      final response = await auth.performRequest(url, {
        'idToken': IdToken,
        'localId': userId,
        'returnSecureToken': true,
      });
      if (response.statusCode == 200) {
        log("User is Updated");
      } else {
        log('update : ${response.body}');
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
