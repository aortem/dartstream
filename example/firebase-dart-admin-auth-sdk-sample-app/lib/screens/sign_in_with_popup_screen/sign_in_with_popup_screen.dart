import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';

class SignInWithPopupScreen extends StatelessWidget {
  const SignInWithPopupScreen({Key? key}) : super(key: key);

  Future<void> _signInWithPopup(BuildContext context, String providerId) async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    try {
      final userCredential = await auth.signInWithPopup(providerId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed in as: ${userCredential.user.email}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in with popup: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In with Popup')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _signInWithPopup(context, 'google.com'),
              child: Text('Sign In with Google'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _signInWithPopup(context, 'facebook.com'),
              child: Text('Sign In with Facebook'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
