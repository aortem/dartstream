import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/utils.dart';

class EmailLinkAuth {
  final FirebaseAuth auth;

  EmailLinkAuth(this.auth);

  Future<void> sendSignInLinkToEmail(String email,
      {ActionCodeSettings? actionCode}) async {
    await auth.performRequest('sendOobCode', {
      'requestType': 'EMAIL_SIGNIN',
      'email': email,
      if (actionCode != null) ...actionCode.toMap(),
    });
  }

  Future<UserCredential> signInWithEmailLink(
      String email, String emailLink) async {
    final response = await auth.performRequest('signInWithEmailLink', {
      'email': email,
      'oobCode': extractOobCode(emailLink),
    });

    final userCredential = UserCredential.fromJson(response.body);
    auth.updateCurrentUser(userCredential.user);
    return userCredential;
  }

  String extractOobCode(String emailLink) {
    final uri = Uri.parse(emailLink);
    return uri.queryParameters['oobCode'] ?? '';
  }

  bool isSignInWithEmailLink(String emailLink) {
    final Uri? uri = Uri.tryParse(emailLink);
    if (uri == null) return false;

    final String? mode = uri.queryParameters['mode'];
    final String? oobCode = uri.queryParameters['oobCode'];

    return mode == 'signIn' && oobCode != null && oobCode.isNotEmpty;
  }
}
