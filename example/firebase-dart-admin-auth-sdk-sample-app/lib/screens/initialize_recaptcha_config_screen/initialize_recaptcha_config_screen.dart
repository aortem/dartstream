import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';

class InitializeRecaptchaConfigScreen extends StatelessWidget {
  const InitializeRecaptchaConfigScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Initialize reCAPTCHA Config'),
      ),
      body: Center(
        child: Button(
          onTap: () async {
            try {
              await FirebaseApp.firebaseAuth?.initializeRecaptchaConfig();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('reCAPTCHA config initialized successfully')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}')),
              );
            }
          },
          title: 'Initialize reCAPTCHA Config',
        ),
      ),
    );
  }
}
