import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';

class InitializeRecaptchaConfigScreen extends StatelessWidget {
  const InitializeRecaptchaConfigScreen({Key? key}) : super(key: key);

  Future<void> _initializeRecaptchaConfig(BuildContext context) async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    try {
      await auth.initializeRecaptchaConfig();
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
