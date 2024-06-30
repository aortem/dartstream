import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/action_code_settings.dart';

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
      'oobCode': extractOobCode(emailLink),
    });

    final userCredential = UserCredential.fromJson(response);
    auth.updateCurrentUser(userCredential.user);
    return userCredential;
  }

  String extractOobCode(String emailLink) {
    final uri = Uri.parse(emailLink);
    return uri.queryParameters['oobCode'] ?? '';
  }
}
