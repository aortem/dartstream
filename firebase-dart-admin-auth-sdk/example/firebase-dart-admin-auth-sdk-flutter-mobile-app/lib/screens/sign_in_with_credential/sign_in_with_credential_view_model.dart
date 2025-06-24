import 'dart:developer';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase/utils/platform_provider.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../home_screen/home_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class SignInWithCredentialViewModel extends ChangeNotifier {
  List<String> scopes = <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  late final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: scopes);

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

  Future<void> loginWithFacebook(BuildContext context) async {
    final LoginResult result = await FacebookAuth.instance
        .login(); // Trigger the sign-in flow
    log("12345result $result");
    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;

      log('Facebook Access Token: ${accessToken.token}');
      try {
        var user = await FirebaseApp.firebaseAuth?.linkAccountWithCredientials(
          'http://localhost',
          accessToken.token,
          'facebook.com',
        );

        var user1 = await FirebaseApp.firebaseAuth?.signInWithRedirect(
          'http://localhost',
          accessToken.token,
          'facebook.com',
        );

        BotToast.showText(text: '${user?.user.email} just linked in');
        BotToast.showText(text: '${user1?.user.email} just linked in11');

        if (user1 != null) {
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

  static final Config config = Config(
    tenant: 'common',
    clientId: 'c51012fe-405f-4516-a838-5cf23fd5640c',
    scope: 'openid profile offline_access',
    navigatorKey: navigatorKey,
    loader: const SizedBox(),
    appBar: AppBar(title: const Text('AAD OAuth Demo')),
    onPageFinished: (String url) {
      log('onPageFinished: $url');
    },
  );
  final AadOAuth oauth = AadOAuth(config);

  void login(bool redirect, BuildContext context) async {
    config.webUseRedirect = redirect;
    final result = await oauth.login();
    result.fold(
      (l) => showError(l.toString(), context),
      (r) =>
          showMessage('Logged in successfully, your access token: $r', context),
    );
    var accessToken = await oauth.getAccessToken();
    if (accessToken != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(accessToken)));
      var user1 = await FirebaseApp.firebaseAuth?.signInWithRedirect(
        'http://localhost',
        accessToken,
        'microsoft.com',
      );

      BotToast.showText(text: '${user1?.user.email} just linked in');
    }
  }

  void showError(dynamic ex, BuildContext context) {
    showMessage(ex.toString(), context);
  }

  void showMessage(String text, BuildContext context) {
    var alert = AlertDialog(
      content: Text(text),
      actions: <Widget>[
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }
}
