import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class FirebaseLinkWithCredentailsUser {
  final FirebaseAuth auth;
  Future<UserCredential> linkCredential(User user, String? idToken) async {
    if (idToken == null) {
      throw FirebaseAuthException(
        code: 'no-id-token',
        message: 'Failed to obtain an ID token for the credential.',
      );
    }

    final response = await auth.performRequest('linkWithCredential', {
      'idToken': idToken,
    });

    if (response.statusCode == 200) {
      final userCredential = UserCredential.fromJson(response.body);
      auth.updateCurrentUser(userCredential.user);
      FirebaseApp.instance.setCurrentUser(userCredential.user);
      return userCredential;
    } else {
      throw FirebaseAuthException(
        code: 'linking-failed',
        message: 'Failed to link credential: ${response.body}',
      );
    }
  }

  FirebaseLinkWithCredentailsUser({required this.auth});
}
