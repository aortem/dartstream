import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';

class CustomTokenAuth {
  final FirebaseAuth auth;

  CustomTokenAuth(this.auth);

  Future<UserCredential> signInWithCustomToken(String token) async {
    final response = await auth.performRequest('signInWithCustomToken', {
      'token': token,
      'returnSecureToken': true,
    });

    final userCredential = UserCredential.fromJson(response.body);
    auth.updateCurrentUser(userCredential.user);
    return userCredential;
  }
}
