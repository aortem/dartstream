import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';

class UpdatePasswordScreenViewModel extends ChangeNotifier {
  bool loading = false;

  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> updatePassword(String newPassowrd) async {
    try {
      setLoading(true);

      await FirebaseApp.firebaseAuth?.updatePassword(newPassowrd);
      BotToast.showText(text: 'Password updated');
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setLoading(false);
    }
  }
}
