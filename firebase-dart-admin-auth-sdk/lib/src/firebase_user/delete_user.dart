import 'dart:developer';

import '../firebase_app.dart';
import '../firebase_auth.dart';
import '../user.dart';

class FirebaseDeleteUser {
  final FirebaseAuth auth;

  FirebaseDeleteUser({required this.auth});

  Future<void> deleteUser(User user) async {
    try {
      final idToken = user.idToken; // Force token refresh
      log("response code ${user.idToken}");
      log("uid${user.uid}");
      if (idToken == null || idToken.isEmpty) {
        log('Error: ID Token is null or empty.');
        return;
      }
      //   {targetProjectId: "fire-base-dart-admin-auth-sdk", localId: "siXwlGYa1RVpvPZyp0qRdaKswPp2"}
      // localId
      //     :
      // "siXwlGYa1RVpvPZyp0qRdaKswPp2"
      // targetProjectId
      //     :
      // "fire-base-dart-admin-auth-sdk"
      // Make the delete request
      final response = await auth.performRequest('delete', {
        // 'idToken': idToken,
        "targetProjectId": FirebaseApp.firebaseAuth?.projectId,
        'localId': user.uid
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
