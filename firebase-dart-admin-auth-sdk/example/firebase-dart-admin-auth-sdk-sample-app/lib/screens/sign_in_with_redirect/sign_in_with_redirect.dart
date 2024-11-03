import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../home_screen/home_screen.dart';

class OAuthSelectionScreen extends StatefulWidget {
  const OAuthSelectionScreen({super.key});

  @override
  State<OAuthSelectionScreen> createState() => _OAuthSelectionScreenState();
}

class _OAuthSelectionScreenState extends State<OAuthSelectionScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'openid',
    ],
  );

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      // Retrieve the authentication tokens (idToken and accessToken)
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      log('Access Token: ${googleAuth.accessToken}');
      log('ID Token: ${googleAuth.idToken}');
      try {
        var user = await FirebaseApp.firebaseAuth?.signInWithRedirect(
            'http://localhost', googleAuth.accessToken ?? "", 'google.com');

        BotToast.showText(text: '${user?.user.email} just signed in');
        log("message$user");
        if (user != null) {
          Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ));
        }
      } catch (e) {
        BotToast.showText(text: e.toString());
      }
      //
    } catch (error) {
      log('Error during Google sign-in: $error');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select OAuth Provider')),
      body: SizedBox(
        width: MediaQuery.of(context).size.width * 1,
        height: 100,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Select OAuth Provider'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Google'),
                          onTap: () {
                            Navigator.of(context).pop();
                            signInWithGoogle();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: const Column(
              children: [
                Text('Sign In'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
