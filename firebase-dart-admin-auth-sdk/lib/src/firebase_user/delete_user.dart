import 'dart:developer';

import '../firebase_app.dart';
import '../firebase_auth.dart';
import '../user.dart';

class FirebaseDeleteUser {
  final FirebaseAuth auth;

  FirebaseDeleteUser({required this.auth});

  Future<void> deleteUser(User user) async {
    try {
      // Fetch a fresh ID token
      final idToken = await user.getIdToken(true); // Force token refresh

      if (idToken == null || idToken.isEmpty) {
        log('Error: ID Token is null or empty.');
        return;
      }

      // Make the delete request
      final response = await auth.performRequest('delete', {
        'idToken': idToken,
      });
      log("response code $response");

      // Handle response
      if (response.statusCode == 200) {
        FirebaseApp.instance.setCurrentUser(null);
        log('User successfully deleted.');
      } else {
        log('Error deleting user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      log('Exception occurred: $e');
    }
  }
}
