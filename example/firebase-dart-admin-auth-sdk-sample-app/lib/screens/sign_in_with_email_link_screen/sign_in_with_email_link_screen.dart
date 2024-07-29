import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/utils/extensions.dart';
import 'package:flutter/material.dart';

class SignInWithEmailLinkScreen extends StatefulWidget {
  const SignInWithEmailLinkScreen({super.key});

  @override
  State<SignInWithEmailLinkScreen> createState() =>
      _SignInWithEmailLinkScreenState();
}

class _SignInWithEmailLinkScreenState extends State<SignInWithEmailLinkScreen> {
  final TextEditingController _emailLinkController = TextEditingController();

  @override
  void dispose() {
    _emailLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: 20.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputField(
                controller: _emailLinkController,
                label: 'Email Link',
                hint: '',
              ),
              20.vSpace,
              Button(
                onTap: () {},
                title: 'Sign In',
              ),
              20.vSpace,
              GestureDetector(
                onTap: () => showSignMethodsBottomSheet(context),
                child: const Text(
                  'Explore more sign in options',
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
