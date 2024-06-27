import 'auth_base.dart';
import '../user_credential.dart';

class CustomTokenAuth extends AuthBase {
  CustomTokenAuth(super.auth);

  Future<UserCredential> signIn(String token) async {
    final response = await _performRequest('signInWithCustomToken', {
      'token': token,
      'returnSecureToken': true,
    });

    final userCredential = UserCredential.fromJson(response);
    _auth._updateCurrentUser(userCredential.user);
    return userCredential;
  }
}
