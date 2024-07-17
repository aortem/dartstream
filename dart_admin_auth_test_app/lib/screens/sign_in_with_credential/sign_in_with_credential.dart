import 'dart:io';
import 'package:dart_admin_auth_test_app/shared/shared.dart';
import 'package:flutter/material.dart';

class SignInWithCredential extends StatelessWidget {
  const SignInWithCredential({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              onTap: () {},
              title: 'Sign In With Google',
            );
          },
        ),
      ),
    );
  }
}
