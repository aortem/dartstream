import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';

class SignInWithPopupScreen extends StatefulWidget {
  const SignInWithPopupScreen({Key? key}) : super(key: key);

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
      appBar: AppBar(title: Text('Sign In with Popup Test')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () => _signInWithPopup(context, GoogleAuthProvider()),
              child: Text('Sign In with Google'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () =>
                  _signInWithPopup(context, FacebookAuthProvider()),
              child: Text('Sign In with Facebook'),
            ),
            SizedBox(height: 20),
            Text(
              'Result:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
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
