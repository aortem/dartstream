import 'package:dart_admin_auth_test_app/screens/home_screen/home_screen.dart';
import 'package:dart_admin_auth_test_app/shared/shared.dart';
import 'package:dart_admin_auth_test_app/utils/extensions.dart';
import 'package:flutter/material.dart';

class SignInWithEmailAndPasswordScreen extends StatefulWidget {
  const SignInWithEmailAndPasswordScreen({super.key});

  @override
  State<SignInWithEmailAndPasswordScreen> createState() =>
      _SignInWithEmailAndPasswordScreenState();
}

class _SignInWithEmailAndPasswordScreenState
    extends State<SignInWithEmailAndPasswordScreen> {
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
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: 20.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InputField(
                controller: _emailController,
                hint: 'test@gmail.com',
                label: 'Email',
              ),
              20.vSpace,
              InputField(
                controller: _passwordController,
                hint: '******',
                label: 'Password',
                obscure: true,
              ),
              20.vSpace,
              Button(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    )),
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
