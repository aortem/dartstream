import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class InitializeRecaptchaConfigScreen extends StatelessWidget {
  final FirebaseAuth auth;

  const InitializeRecaptchaConfigScreen({Key? key, required this.auth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Initialize reCAPTCHA Config'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              await auth.initializeRecaptchaConfig();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('reCAPTCHA config initialized successfully'),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Text('Initialize reCAPTCHA Config'),
        ),
      ),
    );
  }
}
