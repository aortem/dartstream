import 'auth_base.dart';
import '../user_credential.dart';
import '../utils.dart';

class EmailLinkAuth extends AuthBase {
  EmailLinkAuth(super.auth);

  Future<void> sendSignInLinkToEmail(
      String email, ActionCodeSettings actionCodeSettings) async {
    await _performRequest('sendOobCode', {
      'requestType': 'EMAIL_SIGNIN',
      'email': email,
      ...actionCodeSettings.toMap(),
    });
  }

  Future<UserCredential> signInWithEmailLink(
      String email, String emailLink) async {
    final response = await _performRequest('signInWithEmailLink', {
      'email': email,
      'oobCode': Uri.parse(emailLink).queryParameters['oobCode'],
    });

    final userCredential = UserCredential.fromJson(response);
    _auth._updateCurrentUser(userCredential.user);
    return userCredential;
  }
}
