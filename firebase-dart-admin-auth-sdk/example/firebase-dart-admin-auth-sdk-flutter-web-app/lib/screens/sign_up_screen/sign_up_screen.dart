import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase/screens/home_screen/home_screen.dart';
import 'package:firebase/shared/shared.dart';
import 'package:firebase/utils/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'sign_up_view_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    return ChangeNotifierProvider(
      create: (context) => SignUpViewModel(auth),
      child: Consumer<SignUpViewModel>(
        builder: (context, value, child) => Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: 20.all,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputField(
                      label: 'Email',
                      hint: '1234@gmail.com',
                      controller: _emailController,
                    ),
                    30.vSpace,
                    InputField(
                      label: 'Password',
                      hint: '******',
                      controller: _passwordController,
                      obscure: true,
                    ),
                    30.vSpace,
                    Button(
                      onTap: () => value.signUp(
                        _emailController.text,
                        _passwordController.text,
                        () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                      ),
                      loading: value.loading,
                      title: 'Sign Up',
                    ),
                    20.vSpace,
                    Text.rich(
                      textAlign: TextAlign.end,
                      TextSpan(
                        text: 'Have an account? ',
                        children: [
                          TextSpan(
                            text: 'Sign In With Varieties Of Method',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  showSignMethodsBottomSheet(context),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.purple,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
