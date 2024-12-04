// ignore_for_file: use_build_context_synchronously

import 'package:firebase/screens/sign_in_with_credential/sign_in_with_credential.dart';
import 'package:firebase/screens/sign_in_with_email_and_password_screen/sign_in_with_email_and_password_screen.dart';
import 'package:firebase/screens/sign_in_with_email_link_screen/send_sign_in_with_email_link_screen.dart';
import 'package:firebase/screens/sign_in_with_phone_number_screen/sign_in_with_phone_number_screen.dart';
import 'package:firebase/screens/sign_in_with_custom_token_screen/sign_in_with_custom_token_screen.dart';
import 'package:firebase/screens/sign_in_with_popup_screen/sign_in_with_popup_screen.dart';
import 'package:firebase/shared/shared.dart';
import 'package:firebase/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:firebase/screens/apple_sign_in_screen/apple_sign_in_screen.dart';
import 'package:firebase/screens/gcp_sign_in_screen/gcp_sign_in_screen.dart';

import '../screens/sign_in_with_redirect/sign_in_with_redirect.dart';

void showSignMethodsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) => const SignInMethodsBottomSheet(),
  );
}

class SignInMethodsBottomSheet extends StatelessWidget {
  const SignInMethodsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: controller,
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
                    builder: (context) => const SignInWithCustomTokenScreen(),
                  ),
                ),
                title: "Sign In With Custom Token",
              ),
              20.vSpace,
              ActionTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInWithPopupScreen(),
                  ),
                ),
                title: "Sign In With Pop Up",
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
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GCPSignInScreen(),
                  ),
                ),
                title: "Sign In With GCP",
              ),
              20.vSpace,
              ActionTile(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AppleSignInScreen(),
                  ),
                ),
                title: "Sign In With Apple",
              ),
              // 20.vSpace,
              // ActionTile(
              //   onTap: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const GetRedirectResultScreen(),
              //     ),
              //   ),
              //   title: "Get Redirect Result Screen",
              // ),
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
            ],
          ),
        );
      },
    );
  }
}
