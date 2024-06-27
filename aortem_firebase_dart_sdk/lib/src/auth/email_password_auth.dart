import 'auth_base.dart';
import '../user_credential.dart';
import '../exceptions.dart';
import '../utils.dart';

class EmailPasswordAuth extends AuthBase {
  EmailPasswordAuth(super.auth);

  Future<UserCredential> signIn(String email, String password) async {
    if (validateEmail(email) != null) {
      throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'The email address is badly formatted.');
    }

    if (validatePassword(password) != null) {
      throw FirebaseAuthException(
          code: 'weak-password',
          message: 'The password must be at least 6 characters long.');
    }

    final response = await _performRequest('signInWithPassword', {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });

    final userCredential = UserCredential.fromJson(response);
    _auth._updateCurrentUser(userCredential.user);
    return userCredential;
  }

  Future<UserCredential> signUp(String email, String password) async {
    if (validateEmail(email) != null) {
      throw FirebaseAuthException(
          code: 'invalid-email',
          message: 'The email address is badly formatted.');
    }

    if (validatePassword(password) != null) {
      throw FirebaseAuthException(
          code: 'weak-password',
          message: 'The password must be at least 6 characters long.');
    }

    final response = await _performRequest('signUp', {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    });

    final userCredential = UserCredential.fromJson(response);
    _auth._updateCurrentUser(userCredential.user);
    return userCredential;
  }
}
