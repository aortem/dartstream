// initialize_recaptcha_config_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';

class InitializeRecaptchaConfigScreen extends StatefulWidget {
  const InitializeRecaptchaConfigScreen({Key? key}) : super(key: key);

  @override
  _InitializeRecaptchaConfigScreenState createState() =>
      _InitializeRecaptchaConfigScreenState();
}

class _InitializeRecaptchaConfigScreenState
    extends State<InitializeRecaptchaConfigScreen> {
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Initialize reCAPTCHA Config'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Button(
              onTap: () async {
                try {
                  await FirebaseAuth(
                          apiKey: 'your_api_key', projectId: 'your_project_id')
                      .initializeRecaptchaConfig();
                  setState(() {
                    _result = 'reCAPTCHA config initialized successfully';
                  });
                } catch (e) {
                  setState(() {
                    _result = 'Error: ${e.toString()}';
                  });
                }
              },
              title: 'Initialize reCAPTCHA Config',
            ),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
