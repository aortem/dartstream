import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';

class SignInWithPhoneNumberScreen extends StatefulWidget {
  @override
  _SignInWithPhoneNumberScreenState createState() =>
      _SignInWithPhoneNumberScreenState();
}

class _SignInWithPhoneNumberScreenState
    extends State<SignInWithPhoneNumberScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  final TextEditingController _recaptchaSiteKeyController =
      TextEditingController();

  ConfirmationResult? _confirmationResult;
  bool _codeSent = false;
  bool _isLoading = false;
  bool _recaptchaInitialized = false;

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = Provider.of<FirebaseAuth>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In with Phone Number'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _recaptchaSiteKeyController,
                    decoration: InputDecoration(
                      labelText: 'reCAPTCHA Site Key',
                      hintText: 'Enter your reCAPTCHA site key',
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _initializeRecaptchaConfig(auth),
                    child: Text('Initialize reCAPTCHA Config'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: '+1234567890',
                    ),
                    keyboardType: TextInputType.phone,
                    enabled: _recaptchaInitialized,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _recaptchaInitialized
                        ? () => _sendVerificationCode(auth)
                        : null,
                    child: Text('Send Verification Code'),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _smsCodeController,
                    decoration: InputDecoration(labelText: 'Verification Code'),
                    keyboardType: TextInputType.number,
                    enabled: _codeSent,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _codeSent ? () => _verifyCode(auth) : null,
                    child: Text('Verify Code'),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _initializeRecaptchaConfig(FirebaseAuth auth) async {
    setState(() => _isLoading = true);
    try {
      final siteKey = _recaptchaSiteKeyController.text.trim();
      if (siteKey.isEmpty) {
        throw Exception('reCAPTCHA site key cannot be empty');
      }
      await auth.initializeRecaptchaConfig(siteKey);
      setState(() => _recaptchaInitialized = true);
      _showSnackBar('reCAPTCHA config initialized successfully');
    } catch (e) {
      _showSnackBar('Failed to initialize reCAPTCHA config: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _sendVerificationCode(FirebaseAuth auth) async {
    setState(() => _isLoading = true);
    try {
      final phoneNumber = _phoneNumberController.text.trim();
      final recaptchaVerifier =
          RecaptchaVerifier(_recaptchaSiteKeyController.text.trim());

      _confirmationResult = await auth.signInWithPhoneNumber(
        phoneNumber,
        recaptchaVerifier,
      );

      setState(() {
        _codeSent = true;
      });
      _showSnackBar('Verification code sent');
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifyCode(FirebaseAuth auth) async {
    setState(() => _isLoading = true);
    try {
      final smsCode = _smsCodeController.text.trim();
      if (_confirmationResult == null) {
        throw Exception('No confirmation result available');
      }

      final userCredential = await _confirmationResult!.confirm(smsCode);
      _showSnackBar('Signed in successfully: ${userCredential.user.uid}');
      Navigator.of(context).pop(); // Return to previous screen
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
