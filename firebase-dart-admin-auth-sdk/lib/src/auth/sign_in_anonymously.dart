import 'dart:developer';

import '../../firebase_dart_admin_auth_sdk.dart';

class FirebaseSignInAnonymously {
  final FirebaseAuth auth;

  FirebaseSignInAnonymously(this.auth);
  Future<UserCredential?> signInAnonymously() async {
    final response = await auth.performRequest('signUp', {
      // 'idToken': idToken,
      'returnSecureToken': true,
    });
    if (response.statusCode == 200) {
      final userCredential = UserCredential.fromJson(response.body);
      auth.updateCurrentUser(userCredential.user);
      log("current user data ${userCredential.user.idToken}");
      FirebaseApp.instance.setCurrentUser(userCredential.user);

      return userCredential; // final data = json.decode(response.body);
    } else {
      log('Error signing in: ${response.body}');
      return null;
    }
  }
}
