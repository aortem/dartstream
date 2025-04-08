import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../home_screen/home_screen.dart';

import 'package:google_identity_services_web/id.dart';
import 'package:google_identity_services_web/loader.dart' as gis;
import 'package:google_identity_services_web/oauth2.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SignInWithPopupScreen extends StatefulWidget {
  const SignInWithPopupScreen({super.key});

  @override
  State<SignInWithPopupScreen> createState() => _SignInWithPopupScreenState();
}

class _SignInWithPopupScreenState extends State<SignInWithPopupScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
      'openid',
    ],
  );

  bool isLoading = false;

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (kIsWeb) {
        // 🌐 Web-specific Google Sign-In
        print("its web");

        await gis.loadWebSdk();
        id.setLogLevel('debug');
        const List<String> scopes = <String>[
          'https://www.googleapis.com/auth/userinfo.profile',
          'https://www.googleapis.com/auth/userinfo.email',
        ];
        final config = TokenClientConfig(
          client_id:
              '473309149917-5n0s3r0sei7a64dsq0pk0j26oklr0kv0.apps.googleusercontent.com', // Replace!
          scope: scopes,
          callback: (TokenResponse token) async {
            if (token.error != null) {
              throw Exception('Google OAuth error: ${token.error}');
            }
            try {
              final provider = GoogleAuthProvider();
              final userCredential =
                  await FirebaseApp.firebaseAuth?.signInWithPopup(
                provider,
                token.access_token ?? "",
              );

              if (userCredential != null) {
                BotToast.showText(
                    text:
                        '${userCredential.user.email} signed in successfully');

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

            // await FirebaseApp.firebaseAuth?.signInWithCredential(credential);
          },
          error_callback: (error) {
            throw Exception('Google OAuth failed: ${error?.message}');
          },
        );

        final client = oauth2.initTokenClient(config);
        client.requestAccessToken();
      } else {
        // 📱 Mobile-specific Google Sign-In
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          BotToast.showText(text: 'Sign in cancelled');
          return;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        try {
          final provider = GoogleAuthProvider();
          final userCredential =
              await FirebaseApp.firebaseAuth?.signInWithPopup(
            provider,
            googleAuth.accessToken ?? "",
          );

          if (userCredential != null) {
            BotToast.showText(
                text: '${userCredential.user.email} signed in successfully');

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
      appBar: AppBar(
        title: const Text('Sign In with Popup'),
      ),
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
