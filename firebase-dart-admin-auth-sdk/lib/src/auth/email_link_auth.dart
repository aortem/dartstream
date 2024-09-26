import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'dart:developer' as developer;

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
    if (!isSignInWithEmailLink(emailLink)) {
      throw FirebaseAuthException(
        code: 'invalid-email-link',
        message: 'The provided email link is not valid for sign-in.',
      );
    }

    try {
      final response = await auth.performRequest('signInWithEmailLink', {
        'email': email,
        'oobCode': _extractOobCode(emailLink),
      });

      final userCredential = UserCredential.fromJson(response.body);
      auth.updateCurrentUser(userCredential.user);
      developer.log('Signed in successfully with email link',
          name: 'EmailLinkAuth');
      return userCredential;
    } catch (e) {
      developer.log('Failed to sign in with email link: $e',
          name: 'EmailLinkAuth', error: e);
      throw FirebaseAuthException(
        code: 'email-link-sign-in-failed',
        message: 'Failed to sign in with email link: ${e.toString()}',
      );
    }
  }

  bool isSignInWithEmailLink(String emailLink) {
    try {
      final uri = Uri.parse(emailLink);
      final mode = uri.queryParameters['mode'];
      final oobCode = uri.queryParameters['oobCode'];

      return mode == 'signIn' && oobCode != null && oobCode.isNotEmpty;
    } catch (e) {
      developer.log('Invalid email link format: $e',
          name: 'EmailLinkAuth', error: e);
      return false;
    }
  }

  String _extractOobCode(String emailLink) {
    try {
      final uri = Uri.parse(emailLink);
      return uri.queryParameters['oobCode'] ?? '';
    } catch (e) {
      developer.log('Failed to extract oobCode: $e',
          name: 'EmailLinkAuth', error: e);
      throw FirebaseAuthException(
        code: 'invalid-email-link',
        message: 'Failed to extract oobCode from email link.',
      );
    }
  }
}
