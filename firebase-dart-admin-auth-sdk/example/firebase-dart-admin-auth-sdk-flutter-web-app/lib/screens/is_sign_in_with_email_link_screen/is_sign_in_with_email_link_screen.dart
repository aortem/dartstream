// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';

class IsSignInWithEmailLinkScreen extends StatefulWidget {
  const IsSignInWithEmailLinkScreen({super.key});

  @override
  _IsSignInWithEmailLinkScreenState createState() =>
      _IsSignInWithEmailLinkScreenState();
}

class _IsSignInWithEmailLinkScreenState
    extends State<IsSignInWithEmailLinkScreen> {
  final TextEditingController _linkController = TextEditingController();
  bool? _isValidLink;

  void _checkLink() {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    setState(() {
      _isValidLink = auth.isSignInWithEmailLink(_linkController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check Email Sign-In Link')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _linkController,
              decoration: const InputDecoration(
                labelText: 'Email Sign-In Link',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkLink,
              child: const Text('Check Link'),
            ),
            const SizedBox(height: 16),
            if (_isValidLink != null)
              Text(
                _isValidLink!
                    ? 'Valid email sign-in link'
                    : 'Invalid email sign-in link',
                style: TextStyle(
                  color: _isValidLink! ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
