import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class SignInWithPhoneNumberScreen extends StatefulWidget {
  const SignInWithPhoneNumberScreen({Key? key}) : super(key: key);

  @override
  State<SignInWithPhoneNumberScreen> createState() =>
      _SignInWithPhoneNumberScreenState();
}

class _SignInWithPhoneNumberScreenState
    extends State<SignInWithPhoneNumberScreen> {
  final _phoneNumberController = TextEditingController();
  final _smsCodeController = TextEditingController();
  String? _verificationId;
  bool _codeSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _smsCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In with Phone Number')),
      body: Center(
        child: SingleChildScrollView(
          padding: 20.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputField(
                controller: _phoneNumberController,
                label: 'Phone number',
                hint: '+1234567890',
                textInputType: TextInputType.phone,
              ),
              20.vSpace,
              if (!_codeSent)
                Button(
                  onTap: _sendVerificationCode,
                  title: 'Send Verification Code',
                  loading: _isLoading,
                )
              else ...[
                InputField(
                  controller: _smsCodeController,
                  label: 'SMS Code',
                  hint: '123456',
                  textInputType: TextInputType.number,
                ),
                20.vSpace,
                Button(
                  onTap: _verifyPhoneNumber,
                  title: 'Verify and Sign In',
                  loading: _isLoading,
                ),
              ],
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

  Future<void> _sendVerificationCode() async {
    setState(() => _isLoading = true);
    try {
      final auth = FirebaseApp.instance.getAuth();
      _verificationId =
          await auth.phone.sendVerificationCode(_phoneNumberController.text);
      setState(() {
        _codeSent = true;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification code sent')),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _verifyPhoneNumber() async {
    if (_verificationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please send verification code first')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final auth = FirebaseApp.instance.getAuth();
      final userCredential = await auth.signInWithPhoneNumber(
          _verificationId!, _smsCodeController.text);
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Successfully signed in: ${userCredential.user.uid}')),
      );
      // Navigate to home screen or next page
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }
}
