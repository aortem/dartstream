import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';

class SignInWithPopupScreen extends StatefulWidget {
  const SignInWithPopupScreen({super.key});

  @override
  _SignInWithPopupScreenState createState() => _SignInWithPopupScreenState();
}

class _SignInWithPopupScreenState extends State<SignInWithPopupScreen> {
  String _resultMessage = '';

  Future<void> _signInWithPopup(
      BuildContext context, AuthProvider provider) async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    setState(() {
      _resultMessage = 'Signing in...';
    });

    try {
      final userCredential = await auth.signInWithPopup(provider);
      setState(() {
        _resultMessage = 'Signed in as: ${userCredential.user.email}\n'
            'Provider: ${provider.providerId}\n'
            'UID: ${userCredential.user.uid}';
      });
    } catch (e) {
      setState(() {
        _resultMessage = 'Failed to sign in: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In with Popup Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _signInWithPopup(context, GoogleAuthProvider()),
              child: const Text('Sign In with Google'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () =>
                  _signInWithPopup(context, FacebookAuthProvider()),
              child: const Text('Sign In with Facebook'),
            ),
            const SizedBox(height: 20),
            const Text(
              'Result:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SingleChildScrollView(
                  child: Text(_resultMessage),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
