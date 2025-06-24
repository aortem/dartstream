import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:google_identity_services_web/id.dart';
import 'package:google_identity_services_web/loader.dart' as gis;
import 'package:google_identity_services_web/oauth2.dart';
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
      if (kIsWeb) {
        // 🌐 Web-specific flow using Firebase Auth signInWithPopup

        await gis.loadWebSdk();
        id.setLogLevel('debug');
        const List<String> scopes = <String>[
          'https://www.googleapis.com/auth/userinfo.profile',
          'https://www.googleapis.com/auth/userinfo.email',
        ];
        final config = TokenClientConfig(
          client_id: 'your apps.googleusercontent com', // Replace!
          scope: scopes,
          callback: (TokenResponse token) async {
            if (token.error != null) {
              throw Exception('Google OAuth error: ${token.error}');
            }

            try {
              final user = await FirebaseApp.firebaseAuth
                  ?.linkAccountWithCredientials(
                    'http://localhost',
                    token.access_token ?? "",
                    'google.com',
                  );

              if (user != null) {
                BotToast.showText(text: 'Account linked');
                log("Linked user: $user");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }
            } catch (e) {
              BotToast.showText(text: e.toString());
              log('Linking error: $e');
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
        // 📱 Mobile (Android/iOS) flow
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          log('User cancelled the sign-in');
          return null;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        log('Access Token: ${googleAuth.accessToken}');
        log('ID Token: ${googleAuth.idToken}');

        try {
          final user = await FirebaseApp.firebaseAuth
              ?.linkAccountWithCredientials(
                'http://localhost',
                googleAuth.accessToken ?? "",
                'google.com',
              );

          if (user != null) {
            BotToast.showText(text: 'Account linked');
            log("Linked user: $user");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
            return user.user;
          }
        } catch (e) {
          BotToast.showText(text: e.toString());
          log('Linking error: $e');
        }
      }
    } catch (error) {
      log('Error during Google sign-in: $error');
      BotToast.showText(text: 'Sign-in error: $error');
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
