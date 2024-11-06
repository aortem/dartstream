import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class InitializeRecaptchaConfigScreen extends StatelessWidget {
  final FirebaseAuth auth;

  const InitializeRecaptchaConfigScreen({Key? key, required this.auth})
      : super(key: key);

  Future<void> _initializeRecaptchaConfig(BuildContext context) async {
    try {
      // TODO: Replace with your actual reCAPTCHA site key
      const String siteKey =
          'YOUR_RECAPTCHA_SITE_KEY'; //'YOUR_RECAPTCHA_SITE_KEY';
      await auth.initializeRecaptchaConfig(siteKey);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('reCAPTCHA config initialized successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to initialize reCAPTCHA config: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Initialize reCAPTCHA Config')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _initializeRecaptchaConfig(context),
          child: Text('Initialize reCAPTCHA Config'),
        ),
      ),
    );
  }
}
