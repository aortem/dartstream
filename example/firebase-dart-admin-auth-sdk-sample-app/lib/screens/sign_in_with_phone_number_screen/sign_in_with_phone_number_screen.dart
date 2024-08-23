import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class PhoneAuthTestScreen extends StatefulWidget {
  @override
  _PhoneAuthTestScreenState createState() => _PhoneAuthTestScreenState();
}

class _PhoneAuthTestScreenState extends State<PhoneAuthTestScreen> {
  final FirebaseAuth _auth = FirebaseAuth();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();

  String _verificationId = '';
  bool _codeSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Authentication Test'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Send Verification Code'),
              onPressed: _sendVerificationCode,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _smsCodeController,
              decoration: InputDecoration(labelText: 'SMS Code'),
              keyboardType: TextInputType.number,
              enabled: _codeSent,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Verify and Sign In'),
              onPressed: _codeSent ? _verifyAndSignIn : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendVerificationCode() async {
    try {
      final phoneNumber = _phoneNumberController.text.trim();
      final appVerifier = RecaptchaVerifier(
        container: 'recaptcha-container',
        size: RecaptchaVerifierSize.invisible,
        theme: RecaptchaVerifierTheme.light,
      );

      final ConfirmationResult confirmationResult =
          await _auth.signInWithPhoneNumber(phoneNumber, appVerifier);

      setState(() {
        _verificationId = confirmationResult.verificationId;
        _codeSent = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification code sent')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _verifyAndSignIn() async {
    try {
      final smsCode = _smsCodeController.text.trim();
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: smsCode,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential) as UserCredential;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Successfully signed in: ${userCredential.user?.uid}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
