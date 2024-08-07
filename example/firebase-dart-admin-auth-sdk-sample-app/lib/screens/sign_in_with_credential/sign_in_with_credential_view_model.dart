import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_dart_admin_auth_sdk/src/action_code_settings.dart'
    as acs;
import 'package:shared_preferences/shared_preferences.dart';

class SignInWithCredentialViewModel extends ChangeNotifier {
  List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: scopes,
    clientId:
        '473309149917-5n0s3r0sei7a64dsq0pk0j26oklr0kv0.apps.googleusercontent.com', // Add your web client ID here
  );

  bool loading = false;
  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> signInWithCredential(
      String providerId, VoidCallback onSuccess) async {
    try {
      setLoading(true);

      OAuthCredential credential;

      if (providerId == 'google.com') {
        credential = await _signInWithGoogle();
      } else if (providerId == 'apple.com') {
        credential = await _signInWithApple();
      } else {
        throw Exception("Unsupported provider");
      }

      await FirebaseApp.firebaseAuth?.signInWithCredential(credential);

      onSuccess();
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setLoading(false);
    }
  }

  Future<OAuthCredential> _signInWithGoogle() async {
    var signInAccount = await _googleSignIn.signIn();
    var signInAuth = await signInAccount?.authentication;

    if (signInAuth == null || signInAccount == null) {
      throw Exception("Google Sign-In failed");
    }

    return OAuthCredential(
      providerId: 'google.com',
      accessToken: signInAuth.accessToken,
      idToken: signInAuth.idToken,
    );
  }

  Future<OAuthCredential> _signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    return OAuthCredential(
      providerId: 'apple.com',
      accessToken: appleCredential.authorizationCode,
      idToken: appleCredential.identityToken,
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseApp.firebaseAuth?.sendPasswordResetEmail(email);
      BotToast.showText(text: "Password reset email sent");
    } catch (e) {
      BotToast.showText(
          text: "Failed to send password reset email: ${e.toString()}");
    }
  }

  Future<void> revokeToken(String idToken) async {
    try {
      await FirebaseApp.firebaseAuth?.revokeToken(idToken);
      BotToast.showText(text: "Token revoked successfully");
    } catch (e) {
      BotToast.showText(text: "Failed to revoke token: ${e.toString()}");
    }
  }

  Stream<User?> onIdTokenChanged() {
    return FirebaseApp.firebaseAuth?.onIdTokenChanged() ?? Stream.empty();
  }

  Stream<User?> onAuthStateChanged() {
    return FirebaseApp.firebaseAuth?.onAuthStateChanged() ?? Stream.empty();
  }

  bool isSignInWithEmailLink(String emailLink) {
    return FirebaseApp.firebaseAuth?.isSignInWithEmailLink(emailLink) ?? false;
  }

  Future<void> sendSignInLinkToEmail(
      String email, acs.ActionCodeSettings settings) async {
    try {
      await FirebaseApp.firebaseAuth?.sendSignInLinkToEmail(email, settings);
      BotToast.showText(text: "Sign-in link sent to email");

      // Store the email locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('emailForSignIn', email);
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'operation-not-allowed') {
        BotToast.showText(
            text:
                "Email link sign-in is not enabled. Please enable it in the Firebase Console.");
      } else {
        BotToast.showText(text: "Failed to send sign-in link: ${e.toString()}");
      }
    }
  }

  Future<void> handleSignInLink(String link) async {
    if (FirebaseApp.firebaseAuth?.isSignInWithEmailLink(link) ?? false) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final email = prefs.getString('emailForSignIn');
        if (email != null) {
          final userCredential =
              await FirebaseApp.firebaseAuth?.signInWithEmailLink(email, link);
          if (userCredential != null) {
            BotToast.showText(text: "Successfully signed in with email link");
            // Navigate to your home screen or perform any other action
          }
        } else {
          BotToast.showText(text: "Error: No email found for sign-in");
        }
      } catch (e) {
        BotToast.showText(
            text: "Error signing in with email link: ${e.toString()}");
      }
    }
  }
}
