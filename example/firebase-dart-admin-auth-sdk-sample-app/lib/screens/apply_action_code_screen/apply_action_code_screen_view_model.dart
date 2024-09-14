import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';

class ApplyActionCodeScreenViewModel extends ChangeNotifier {
  bool loading = false;

  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> applyActionCode(String actionCode) async {
    try {
      setLoading(true);

      await FirebaseApp.firebaseAuth?.applyActionCode(actionCode);

      BotToast.showText(text: 'Success');
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setLoading(false);
    }
  }
}
