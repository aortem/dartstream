import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sample_app/utils/platform_provider.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInWithCredentialViewModel extends ChangeNotifier {
  List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: scopes,
  );

  bool loading = false;
  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> signInWithCredential(VoidCallback onSuccess) async {
    try {
      setLoading(true);

      var signInAccount = await _googleSignIn.signIn();

      var signInAuth = await signInAccount?.authentication;

      if (signInAuth == null) {
        throw Exception("Something went wrong");
      }

      OAuthCredential credential = OAuthCredential(
        providerId: getPlatformId(),
        accessToken: signInAuth.accessToken,
        idToken: signInAuth.idToken,
      );

      await FirebaseApp.firebaseAuth?.signInWithCredential(credential);

      onSuccess();
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setLoading(false);
    }
  }
}
