import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:provider/provider.dart';

class InitializeRecaptchaConfigScreen extends StatefulWidget {
  const InitializeRecaptchaConfigScreen({Key? key}) : super(key: key);

  @override
  _InitializeRecaptchaConfigScreenState createState() =>
      _InitializeRecaptchaConfigScreenState();
}

class _InitializeRecaptchaConfigScreenState
    extends State<InitializeRecaptchaConfigScreen> {
  String _result = '';
  bool _isLoading = false;

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
            _isLoading
                ? CircularProgressIndicator()
                : Button(
                    onTap: _initializeRecaptchaConfig,
                    title: 'Initialize reCAPTCHA Config',
                  ),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Future<void> _initializeRecaptchaConfig() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final auth = Provider.of<FirebaseAuth>(context, listen: false);
      await auth.initializeRecaptchaConfig();
      setState(() {
        _result = 'reCAPTCHA config initialized successfully';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
