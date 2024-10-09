import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/home_screen/home_screen.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'sign_in_with_credential_view_model.dart';
import 'package:firebase_dart_admin_auth_sdk/src/action_code_settings.dart'
    as acs;

class SignInWithCredential extends StatelessWidget {
  const SignInWithCredential({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignInWithCredentialViewModel(),
      child: Consumer<SignInWithCredentialViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (kIsWeb)
                  Column(
                    children: [
                      Button(
                        onTap: () => viewModel.signInWithCredential(
                          'google.com',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          ),
                        ),
                        title: 'Sign In With Google',
                      ),
                      SizedBox(height: 20),
                      Button(
                        onTap: () => viewModel.signInWithCredential(
                          'apple.com',
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeScreen()),
                          ),
                        ),
                        title: 'Sign In With Apple',
                      ),
                    ],
                  )
                else if (!kIsWeb && Platform.isIOS)
                  Button(
                    onTap: () => viewModel.signInWithCredential(
                      'apple.com',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      ),
                    ),
                    title: 'Sign In With Apple',
                  )
                else
                  Button(
                    onTap: () => viewModel.signInWithCredential(
                      'google.com',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      ),
                    ),
                    title: 'Sign In With Google',
                  ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
