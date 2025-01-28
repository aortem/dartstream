import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';

class SetLanguageCodeScreenViewModel extends ChangeNotifier {
  bool loading = false;

  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> setLanguageCode(String languageCode) async {
    try {
      setLoading(true);

      await FirebaseApp.firebaseAuth?.setLanguageCode(languageCode);

      BotToast.showText(text: 'Success');
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setLoading(false);
    }
  }
}
