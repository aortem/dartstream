import 'package:dart_admin_auth_test_app/screens/sign_in_with_credential/sign_in_with_credential.dart';
import 'package:dart_admin_auth_test_app/screens/sign_in_with_email_and_password_screen/sign_in_with_email_and_password_screen.dart';
import 'package:dart_admin_auth_test_app/screens/sign_in_with_email_link_screen/sign_in_with_email_link_screen.dart';
import 'package:dart_admin_auth_test_app/screens/sign_in_with_phone_number_screen/sign_in_with_phone_number_screen.dart';
import 'package:dart_admin_auth_test_app/shared/shared.dart';
import 'package:dart_admin_auth_test_app/utils/extensions.dart';
import 'package:flutter/material.dart';

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
    return Container(
      padding: 20.all,
      child: Column(
        children: [
          ActionTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInWithEmailAndPasswordScreen(),
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
                builder: (context) => const SignInWithEmailLinkScreen(),
              ),
            ),
            title: "Sign In With Email Link",
          ),
          20.vSpace,
          ActionTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInWithCredential(),
              ),
            ),
            title: "Sign In With Credential",
          ),
        ],
      ),
    );
  }
}
