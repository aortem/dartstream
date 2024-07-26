import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class UpdateCurrentUser {
  final FirebaseAuth auth;

  UpdateCurrentUser({required this.auth});

  Future<void> updateCurrentUser(String userId,
      [Map<String, dynamic>? userData]) async {
    try {
      final url = 'update';

      await auth.performRequest(url, {
        'idToken': userId,
        "userData": [],
      });
    } catch (e) {
      print('Update current user failed: $e');
      throw FirebaseAuthException(
        code: 'update-current-user-error',
        message: 'Failed to update current user.',
      );
    }
  }
}
