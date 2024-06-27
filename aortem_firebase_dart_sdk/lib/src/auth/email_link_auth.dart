import '../firebase_auth.dart';
import '../user_credential.dart';
import '../utils.dart';

class EmailLinkAuth {
  final FirebaseAuth auth;

  EmailLinkAuth(this.auth);

  Future<void> sendSignInLinkToEmail(
      String email, ActionCodeSettings settings) async {
    await auth.performRequest('sendOobCode', {
      'requestType': 'EMAIL_SIGNIN',
      'email': email,
      ...settings.toMap(),
    });
  }

  Future<UserCredential> signInWithEmailLink(
      String email, String emailLink) async {
    final response = await auth.performRequest('signInWithEmailLink', {
      'email': email,
      'oobCode': emailLink,
    });

    final userCredential = UserCredential.fromJson(response);
    auth.updateCurrentUser(userCredential.user);
    return userCredential;
  }
}
