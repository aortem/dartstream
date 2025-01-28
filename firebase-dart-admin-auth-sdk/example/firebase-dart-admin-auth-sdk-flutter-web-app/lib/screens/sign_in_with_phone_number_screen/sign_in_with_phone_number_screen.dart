import 'package:firebase/screens/home_screen/home_screen.dart';
import 'package:firebase/shared/shared.dart';
import 'package:firebase/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign_in_with_phone_number_view_model.dart';

class SignInWithPhoneNumberScreen extends StatefulWidget {
  const SignInWithPhoneNumberScreen({super.key});

  @override
  State<SignInWithPhoneNumberScreen> createState() =>
      _SignInWithPhoneNumberScreenState();
}

class _SignInWithPhoneNumberScreenState
    extends State<SignInWithPhoneNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _smsCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignInWithPhoneNumberViewModel(),
      child: Consumer<SignInWithPhoneNumberViewModel>(
        builder: (context, model, child) => Scaffold(
          appBar: AppBar(title: const Text('Sign In with Phone Number')),
          body: Center(
            child: SingleChildScrollView(
              padding: 20.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InputField(
                    controller: _phoneController,
                    hint: '+16505550101',
                    label: 'Phone Number',
                    textInputType: TextInputType.phone,
                  ),
                  20.vSpace,
                  Button(
                    onTap: model.loading || model.codeSent
                        ? () {}
                        : () =>
                            model.sendVerificationCode(_phoneController.text),
                    title: 'Send Verification Code',
                    loading: model.loading && !model.codeSent,
                  ),
                  if (model.codeSent) ...[
                    20.vSpace,
                    InputField(
                      controller: _smsCodeController,
                      hint: '123456',
                      label: 'SMS Code',
                      textInputType: TextInputType.number,
                    ),
                    20.vSpace,
                    Button(
                      onTap: model.loading
                          ? () {}
                          : () => model.verifyCode(
                                _smsCodeController.text,
                                () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()),
                                  );
                                },
                              ),
                      title: 'Verify Code',
                      loading: model.loading && model.codeSent,
                    ),
                  ],
                  20.vSpace,
                  const Text(
                    'Use Firebase test phone numbers like +16505550101',
                    style: TextStyle(color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
