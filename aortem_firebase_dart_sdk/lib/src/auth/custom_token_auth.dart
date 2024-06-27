import '../firebase_auth.dart';
import '../user_credential.dart';

class CustomTokenAuth {
  final FirebaseAuth auth;

  CustomTokenAuth(this.auth);

  Future<UserCredential> signInWithCustomToken(String token) async {
    final response = await auth.performRequest('signInWithCustomToken', {
      'token': token,
      'returnSecureToken': true,
    });

    final userCredential = UserCredential.fromJson(response);
    auth.updateCurrentUser(userCredential.user);
    return userCredential;
  }
}
