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
    scopes: ['email', 'profile', 'openid'],
  );

  bool isLoading = false;

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
  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (kIsWeb) {
        // 🌐 Web-specific Google Sign-In

        await gis.loadWebSdk();
        id.setLogLevel('debug');
        const List<String> scopes = <String>[
          'https://www.googleapis.com/auth/userinfo.profile',
          'https://www.googleapis.com/auth/userinfo.email',
        ];
        final config = TokenClientConfig(
          client_id: 'your app .apps.googleusercontent.com', // Replace!
          scope: scopes,
          callback: (TokenResponse token) async {
            if (token.error != null) {
              throw Exception('Google OAuth error: ${token.error}');
            }
            try {
              final provider = GoogleAuthProvider();
              final userCredential = await FirebaseApp.firebaseAuth
                  ?.signInWithPopup(provider, token.access_token ?? "");

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
          final userCredential = await FirebaseApp.firebaseAuth
              ?.signInWithPopup(provider, googleAuth.accessToken ?? "");

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
