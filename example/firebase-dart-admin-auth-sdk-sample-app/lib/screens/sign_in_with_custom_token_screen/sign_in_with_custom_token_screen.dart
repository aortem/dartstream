import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';

class SignInWithCustomTokenScreen extends StatefulWidget {
  const SignInWithCustomTokenScreen({Key? key}) : super(key: key);

  @override
  _SignInWithCustomTokenScreenState createState() =>
      _SignInWithCustomTokenScreenState();
}

class _SignInWithCustomTokenScreenState
    extends State<SignInWithCustomTokenScreen> {
  final TextEditingController _tokenController = TextEditingController();

  Future<void> _signInWithCustomToken() async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    try {
      final userCredential =
          await auth.signInWithCustomToken(_tokenController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed in as: ${userCredential.user.email}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with custom token: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In with Custom Token')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tokenController,
              decoration: InputDecoration(labelText: 'Custom Token'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signInWithCustomToken,
              child: Text('Sign In with Custom Token'),
            ),
          ],
        ),
      ),
    );
  }
}
