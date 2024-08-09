import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';

class SignInWithEmailLinkScreen extends StatefulWidget {
  const SignInWithEmailLinkScreen({Key? key}) : super(key: key);

  @override
  _SignInWithEmailLinkScreenState createState() =>
      _SignInWithEmailLinkScreenState();
}

class _SignInWithEmailLinkScreenState extends State<SignInWithEmailLinkScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  Future<void> _signInWithEmailLink() async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    try {
      final userCredential = await auth.signInWithEmailLink(
        _emailController.text,
        _linkController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed in as: ${userCredential.user.email}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with email link: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In with Email Link')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _linkController,
              decoration: InputDecoration(labelText: 'Email Link'),
            ),
            ElevatedButton(
              onPressed: _signInWithEmailLink,
              child: Text('Sign In with Email Link'),
            ),
          ],
        ),
      ),
    );
  }
}
