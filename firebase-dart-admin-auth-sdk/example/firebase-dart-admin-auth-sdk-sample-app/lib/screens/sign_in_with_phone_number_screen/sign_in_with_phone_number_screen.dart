import 'package:firebase/shared/shared.dart';
import 'package:firebase/utils/extensions.dart';
import 'package:flutter/material.dart';

class SignInWithPhoneNumberScreen extends StatefulWidget {
  const SignInWithPhoneNumberScreen({super.key});

  @override
  State<SignInWithPhoneNumberScreen> createState() =>
      _SignInWithPhoneNumberScreenState();
}

class _SignInWithPhoneNumberScreenState
    extends State<SignInWithPhoneNumberScreen> {
  final _phonenumberController = TextEditingController();

  @override
  void dispose() {
    _phonenumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: 20.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InputField(
                controller: _phonenumberController,
                label: 'Phone number',
                hint: '123456789',
                textInputType: TextInputType.phone,
              ),
              20.vSpace,
              Button(
                onTap: () {},
                title: 'Sign In',
              ),
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
}
