import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class SignInWithCustomTokenScreen extends StatefulWidget {
  const SignInWithCustomTokenScreen({Key? key}) : super(key: key);

  @override
  _SignInWithCustomTokenScreenState createState() =>
      _SignInWithCustomTokenScreenState();
}

class _SignInWithCustomTokenScreenState
    extends State<SignInWithCustomTokenScreen> {
  final TextEditingController _tokenController = TextEditingController();

  // WARNING: This method is for testing purposes only!
  // In a real application, custom tokens should be generated on a secure server.
  String _generateTestToken() {
    final payload = {
      'uid': 'test_user_${DateTime.now().millisecondsSinceEpoch}',
      'claims': {'admin': true},
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp':
          DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
    };
    final encodedPayload = base64Url.encode(utf8.encode(json.encode(payload)));
    return 'test_token.$encodedPayload.signature';
  }

  void _generateAndSetTestToken() {
    final testToken = _generateTestToken();
    setState(() {
      _tokenController.text = testToken;
    });
  }

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
              onPressed: _generateAndSetTestToken,
              child: Text('Generate Test Token'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signInWithCustomToken,
              child: Text('Sign In with Custom Token'),
            ),
            SizedBox(height: 32),
            Text(
              'IMPORTANT: In a production environment, custom tokens should be generated on a secure server using the Firebase Admin SDK. The token generation here is for testing purposes only.',
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
