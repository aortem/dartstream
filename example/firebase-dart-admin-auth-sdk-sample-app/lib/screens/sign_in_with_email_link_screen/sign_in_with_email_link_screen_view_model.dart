import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';

class SignInWithEmailLinkScreenViewModel extends ChangeNotifier {
  bool loading = false;

  final FirebaseAuth? _firebaseSdk = FirebaseApp.firebaseAuth;
  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> sendSignInLinkToEmail(String email) async {
    try {
      setLoading(true);

      await _firebaseSdk?.sendSignInLinkToEmail(
        email,
      );
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setLoading(false);
    }
  }
}
