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

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:google_identity_services_web/id.dart';
import 'package:google_identity_services_web/loader.dart' as gis;
import 'package:google_identity_services_web/oauth2.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class MicrosoftSignIn extends ChangeNotifier {
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

  /// Signs in a user with Google and links the account to Firebase.
  ///
  /// This function supports both web and mobile platforms and adapts the
  /// sign-in flow accordingly.
  ///
  /// ---
  ///
  /// 💻 **Web Flow**:
  /// - Uses **Google Identity Services (GIS)** for OAuth2 authentication.
  /// - Loads the GIS SDK dynamically.
  /// - Initializes a `TokenClient` with `client_id`, scopes, and callback functions.
  /// - Upon successful OAuth, links the received `access_token` with Firebase.
  /// - Handles errors via `error_callback`.
  ///
  /// 📱 **Mobile Flow**:
  /// - Uses the `google_sign_in` Flutter plugin.
  /// - Prompts the user to select a Google account.
  /// - Retrieves the `accessToken` and `idToken` after successful authentication.
  /// - Links the `accessToken` with Firebase using a custom linking method.
  ///
  /// ---
  ///
  /// ⚙️ **Requirements**:
  /// - **Web**:
  ///   - A valid OAuth 2.0 `client_id` from Google Developer Console (of type `Web application`).
  ///   - GIS JavaScript SDK properly loaded.
  ///   - Allowed redirect URI (e.g., `http://localhost` during development).
  /// - **Mobile**:
  ///   - The `google_sign_in` package must be configured with the correct `client_id`
  ///     in the `google-services.json` / `GoogleService-Info.plist`.
  ///   - The `FirebaseApp.firebaseAuth?.linkAccountWithCredientials` method must be
  ///     implemented to accept an access token and link to Firebase with the provider ID (`google.com`).
  ///
  /// 🧪 **Note**:
  /// This implementation assumes you have custom Firebase logic to handle
  /// linking accounts via access tokens. You may replace
  /// `linkAccountWithCredientials()` with Firebase's native methods like
  /// `signInWithCredential()` using `GoogleAuthProvider.credential()`,
  /// if you're using the default Firebase SDK.
  ///
  /// ---
  ///
  /// 🧾 **Returns**:
  /// - A [User] object if sign-in and linking succeed.
  /// - `null` if the process is cancelled or an error occurs.
  ///
  /// 📣 **Side Effects**:
  /// - Uses `BotToast.showText()` to show status and error messages.
  /// - Logs debug messages with `log()`.
  /// - Navigates to `HomeScreen` after successful linking.
  ///
  /// ---
  ///
  /// 🔐 Make sure to:
  /// - Replace the placeholder `client_id` with your actual Google Client ID.
  /// - Ensure that Firebase is correctly initialized on both platforms.

  Future<void> signInWithGoogle(VoidCallback onSuccess) async {
    try {
      setLoading(true);

      if (kIsWeb) {
        // WEB FLOW

        log("its web tessss");
        await gis.loadWebSdk();
        id.setLogLevel('debug');
        const List<String> scopes = <String>[
          'https://www.googleapis.com/auth/userinfo.profile',
          'https://www.googleapis.com/auth/userinfo.email',
        ];
        final config = TokenClientConfig(
          client_id: 'your  apps.googleusercontent com', // Replace!
          scope: scopes,
          callback: (TokenResponse token) async {
            if (token.error != null) {
              throw Exception('Google OAuth error: ${token.error}');
            }

            await FirebaseApp.firebaseAuth?.signInWithRedirect(
              'http://localhost',
              token.access_token!,
              'google.com',
            );
            // await FirebaseApp.firebaseAuth?.signInWithCredential(credential);
            onSuccess();
          },
          error_callback: (error) {
            throw Exception('Google OAuth failed: ${error?.message}');
          },
        );

        final client = oauth2.initTokenClient(config);
        client.requestAccessToken();
      } else {
        // NON-WEB FLOW (Android/iOS/Desktop)
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
      }
    } catch (e) {
      BotToast.showText(text: e.toString());
    } finally {
      setLoading(false);
    }
  }
  ////////////////////////////////////////////////

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

  void signInWithMicrosoft(bool redirect, BuildContext context) async {
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
