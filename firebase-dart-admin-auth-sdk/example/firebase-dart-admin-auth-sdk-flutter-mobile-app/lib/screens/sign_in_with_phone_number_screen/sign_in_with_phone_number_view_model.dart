import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';

class SignInWithPhoneNumberViewModel extends ChangeNotifier {
  bool loading = false;
  bool codeSent = false;
  String? verificationId;

  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  void setCodeSent(bool sent, String? verId) {
    codeSent = sent;
    verificationId = verId;
    notifyListeners();
  }

  Future<void> sendVerificationCode(String phoneNumber) async {
    try {
      setLoading(true);

      // Simulating sending verification code
      await Future.delayed(const Duration(seconds: 2));
      setCodeSent(true, 'test_verification_id');

      BotToast.showText(text: 'Verification code sent to $phoneNumber');
    } catch (e) {
      BotToast.showText(text: 'Failed to send verification code: $e');
    }
    setLoading(false);
  }

  Future<void> verifyCode(String smsCode, VoidCallback onSuccess) async {
    try {
      setLoading(true);

      if (smsCode != '123456') {
        throw FirebaseAuthException(
          code: 'invalid-verification-code',
          message: 'Invalid verification code. Use 123456 for testing.',
        );
      }

      // Simulate sign in
      await Future.delayed(const Duration(seconds: 2));

      onSuccess();
      BotToast.showText(text: 'Signed in successfully');
    } catch (e) {
      BotToast.showText(text: 'Failed to sign in: $e');
    }
    setLoading(false);
  }
}
