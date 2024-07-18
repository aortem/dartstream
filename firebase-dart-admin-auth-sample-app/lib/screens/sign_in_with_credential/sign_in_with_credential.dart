import 'dart:io';
import 'package:dart_admin_auth_sample_app/screens/home_screen/home_screen.dart';
import 'package:dart_admin_auth_sample_app/shared/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'sign_in_with_credential_view_model.dart';

class SignInWithCredential extends StatelessWidget {
  const SignInWithCredential({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignInWithCredentialViewModel(),
      child: Consumer<SignInWithCredentialViewModel>(
        builder: (context, value, child) => Scaffold(
          body: Center(
            child: Builder(
              builder: (context) {
                if (Platform.isIOS) {
                  return Button(
                    onTap: () {},
                    title: 'Sign In With Apple',
                  );
                }
                return Button(
                  onTap: () => value.signInWithCredential(
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    ),
                  ),
                  title: 'Sign In With Google',
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
