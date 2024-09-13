import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';

class HomeScreenViewModel extends ChangeNotifier {
  bool loading = false;
  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> reloadUser() async {
    try {
      setLoading(true);
      await FirebaseApp.firebaseAuth?.reloadUser();
      BotToast.showText(text: 'Reload Successful');
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setLoading(false);
    }
  }

  bool verificationLoading = false;

  void setVerificationLoading(bool load) {
    verificationLoading = load;
    notifyListeners();
  }

  Future<void> sendEmailVerificationCode(VoidCallback onSuccess) async {
    try {
      setVerificationLoading(true);

      await FirebaseApp.firebaseAuth?.sendEmailVerificationCode();

      onSuccess();
      BotToast.showText(text: 'Code Sent');
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setVerificationLoading(false);
    }
  }
}
