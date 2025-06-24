import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';

class SendSignInWithEmailLinkScreenViewModel extends ChangeNotifier {
  bool loading = false;
  bool signingIn = false;

  final FirebaseAuth? _firebaseSdk = FirebaseApp.firebaseAuth;

  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  void setSigningIn(bool value) {
    signingIn = value;
    notifyListeners();
  }

  Future<void> sendSignInLinkToEmail(String email) async {
    try {
      setLoading(true);

      await _firebaseSdk?.sendSignInLinkToEmail(email);

      BotToast.showText(text: 'Sign in link sent to $email');
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<void> signInWithEmailLink(
    String email,
    String emailLink,
    VoidCallback onSuccess,
  ) async {
    try {
      setSigningIn(true);

      final userCredential = await _firebaseSdk?.signInWithEmailLink(
        email,
        emailLink,
      );

      if (userCredential != null) {
        BotToast.showText(
          text: 'Signed in successfully: ${userCredential.user.email}',
        );
        onSuccess();
      } else {
        BotToast.showText(text: 'Failed to sign in');
      }
    } catch (e) {
      BotToast.showText(text: 'Sign in failed: ${e.toString()}');
    } finally {
      setSigningIn(false);
    }
  }
}
