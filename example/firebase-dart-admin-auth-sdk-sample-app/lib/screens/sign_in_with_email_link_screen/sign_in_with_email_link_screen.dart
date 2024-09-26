import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';

class SignInWithEmailLinkScreen extends StatefulWidget {
  const SignInWithEmailLinkScreen({super.key});

  @override
  _SignInWithEmailLinkScreenState createState() =>
      _SignInWithEmailLinkScreenState();
}

class _SignInWithEmailLinkScreenState extends State<SignInWithEmailLinkScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  String _result = '';

  Future<void> _signInWithEmailLink() async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    setState(() {
      _result = 'Signing in...';
    });
    try {
      final userCredential = await auth.signInWithEmailLink(
        _emailController.text,
        _linkController.text,
      );
      setState(() {
        _result = 'Signed in successfully: ${userCredential.user.email}';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In with Email Link')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _linkController,
              decoration: const InputDecoration(labelText: 'Email Link'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signInWithEmailLink,
              child: const Text('Sign In with Email Link'),
            ),
            const SizedBox(height: 16),
            Text(_result, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
