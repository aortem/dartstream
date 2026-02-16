import 'package:flutter/material.dart';
import '../api/auth_api.dart';
import '../services/session_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  String provider = 'okta';
  bool isEmailEmpty = true;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
      );
      return;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    final result = await AuthApi.signIn(email, provider);
    await SessionService.saveSession(result.sessionId);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeScreen(user: result.user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DartStream Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) {
                setState(() {
                  isEmailEmpty = value.trim().isEmpty;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: provider,
              items: const [
                DropdownMenuItem(value: 'okta', child: Text('Okta')),
                DropdownMenuItem(value: 'auth0', child: Text('Auth0')),
                DropdownMenuItem(value: 'cognito', child: Text('Cognito')),
              ],
              onChanged: (v) => setState(() => provider = v!),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: isEmailEmpty ? null : _signIn,
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
