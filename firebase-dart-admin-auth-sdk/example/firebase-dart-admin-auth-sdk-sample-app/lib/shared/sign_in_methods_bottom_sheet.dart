// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase/screens/sign_in_with_credential/sign_in_with_credential.dart';
import 'package:firebase/screens/sign_in_with_email_and_password_screen/sign_in_with_email_and_password_screen.dart';
import 'package:firebase/screens/sign_in_with_email_link_screen/send_sign_in_with_email_link_screen.dart';
import 'package:firebase/screens/sign_in_with_phone_number_screen/sign_in_with_phone_number_screen.dart';
import 'package:firebase/shared/shared.dart';
import 'package:firebase/utils/extensions.dart';
import 'package:flutter/material.dart';

import '../screens/home_screen/home_screen.dart';
import '../screens/sign_in_with_redirect/sign_in_with_redirect.dart';

void showSignMethodsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) => const SignInMethodsBottomSheet(),
  );
}

class SignInMethodsBottomSheet extends StatelessWidget {
  const SignInMethodsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    void homeScreenNaviaget() {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ));
    }

    return Container(
      padding: 20.all,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ActionTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const SignInWithEmailAndPasswordScreen(),
                ),
              ),
              title: "Sign In With Email&Password",
            ),
            20.vSpace,
            ActionTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInWithPhoneNumberScreen(),
                ),
              ),
              title: "Sign In With Phone Number",
            ),
            20.vSpace,
            ActionTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SendSignInWithEmailLinkScreen(),
                ),
              ),
              title: "Sign In With Email Link",
            ),
            20.vSpace,
            ActionTile(
              onTap: () async {
                await FirebaseApp.firebaseAuth
                    ?.signInWithCustomToken(null)
                    .then(
                  (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                );
              },
              title: "Sign In Custom Token",
            ),
            20.vSpace,
            ActionTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInWithCredential(),
                ),
              ),
              title: "Sign In With Credential (AdditionalProviders)",
            ),
            20.vSpace,
            ActionTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OAuthSelectionScreen(),
                ),
              ),
              title: "Sign In With Redirect",
            ),
            20.vSpace,
            ActionTile(
              onTap: () async {
                try {
                  var user =
                      await FirebaseApp.firebaseAuth?.signInAnonymouslyMethod();

                  BotToast.showText(text: '${user?.user.email} just signed in');
                  log("message$user");
                  if (user != null) {
                    homeScreenNaviaget();
                  }
                } catch (e) {
                  BotToast.showText(text: e.toString());
                } finally {}
              },
              //  await FirebaseApp.firebaseAuth?.signInAnonymouslyMethod(),
              title: "Sign In Anonymously ",
            ),
            20.vSpace,
          ],
        ),
      ),
    );
  }
}
