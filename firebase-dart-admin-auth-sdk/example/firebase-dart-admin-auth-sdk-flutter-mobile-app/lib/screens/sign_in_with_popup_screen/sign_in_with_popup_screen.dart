import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../home_screen/home_screen.dart';

class SignInWithPopupScreen extends StatefulWidget {
  const SignInWithPopupScreen({super.key});

  @override
  State<SignInWithPopupScreen> createState() => _SignInWithPopupScreenState();
}

class _SignInWithPopupScreenState extends State<SignInWithPopupScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
  );

  bool isLoading = false;

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        BotToast.showText(text: 'Sign in cancelled');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      try {
        final provider = GoogleAuthProvider();
        final userCredential = await FirebaseApp.firebaseAuth?.signInWithPopup(
          provider,
          googleAuth.accessToken ?? "",
        );

        if (userCredential != null) {
          BotToast.showText(
            text: '${userCredential.user.email} signed in successfully',
          );

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        }
      } catch (e) {
        BotToast.showText(text: 'Sign in failed: ${e.toString()}');
      }
    } catch (error) {
      BotToast.showText(text: 'Error during Google sign-in: $error');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In with Popup')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: signInWithGoogle,
                    icon: const Icon(Icons.login),
                    label: const Text('Sign in with Google'),
                  ),
                ],
              ),
      ),
    );
  }
}
