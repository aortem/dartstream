import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../home_screen/home_screen.dart';

class LinkWithCredentials extends StatefulWidget {
  const LinkWithCredentials({super.key});

  @override
  State<LinkWithCredentials> createState() => _LinkWithCredentialsState();
}

class _LinkWithCredentialsState extends State<LinkWithCredentials> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile', 'openid'],
  );
  // static const clientId = 'YOUR_MICROSOFT_CLIENT_ID';
  // // The redirect URI registered in Azure
  // static const redirectUri = 'http://localhost';
  // static const microsoftAuthUrl = 'https://login.microsoftonline.com/common/oauth2/v2.0/authorize';

  // The endpoint for exchanging authorization code for access token
  // static const tokenUrl = 'https://login.microsoftonline.com/common/oauth2/v2.0/token';

  // Scope for Microsoft OAuth
  //static const scope = 'openid profile User.Read';
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        log('User cancelled the sign-in');
        return null;
      }

      // Retrieve the authentication tokens (idToken and accessToken)
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      log('Access Token: ${googleAuth.accessToken}');
      log('ID Token: ${googleAuth.idToken}');
      try {
        var user = await FirebaseApp.firebaseAuth?.linkAccountWithCredientials(
          'http://localhost',
          googleAuth.accessToken ?? "",
          'google.com',
        );

        BotToast.showText(text: 'Account linked ');
        log("message$user");
        if (user != null) {}
      } catch (e) {
        BotToast.showText(text: e.toString());
      }
      //
    } catch (error) {
      log('Error during Google sign-in: $error');
    }
    return null;
  }

  Future<void> loginWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance
        .login(); // Trigger the sign-in flow

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;

      log('Facebook Access Token: ${accessToken.token}');
      try {
        var user = await FirebaseApp.firebaseAuth?.linkAccountWithCredientials(
          'http://localhost',
          accessToken.token,
          'facebook.com',
        );

        BotToast.showText(text: '${user?.user.email} just linked in');

        if (user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } catch (e) {
        BotToast.showText(text: e.toString());
      }
      // Use this token to authenticate with your backend or Firebase
    } else if (result.status == LoginStatus.cancelled) {
      log('Login cancelled');
    } else {
      log('Facebook login failed: ${result.message}');
    }
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
                        ListTile(
                          title: const Text('Facebook'),
                          onTap: () {
                            // Navigator.of(context).pop();
                            loginWithFacebook();
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: const Text('Link Account'),
          ),
        ),
      ),
    );
  }
}
