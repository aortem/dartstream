import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';

class SignUpViewModel extends ChangeNotifier {
  bool loading = false;
  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> signUp(
    String email,
    String password,
    VoidCallback onSuccess,
  ) async {
    try {
      setLoading(true);

      var user = await FirebaseApp.firebaseAuth
          ?.createUserWithEmailAndPassword(email, password);

      BotToast.showText(text: '${user?.email} just signed in');
      onSuccess();
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setLoading(false);
    }
  }
}
