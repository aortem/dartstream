// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';

class RevokeAccessTokenScreen extends StatefulWidget {
  const RevokeAccessTokenScreen({super.key});

  @override
  _RevokeAccessTokenScreenState createState() =>
      _RevokeAccessTokenScreenState();
}

class _RevokeAccessTokenScreenState extends State<RevokeAccessTokenScreen> {
  String _result = '';

  Future<void> _revokeAccessToken() async {
    setState(() {
      _result = 'Revoking access token...';
    });

    try {
      final auth = Provider.of<FirebaseAuth>(context, listen: false);

      // Revoke the token
      await auth.revokeToken('');

      setState(() {
        _result =
            'Access token revoked successfully. You have been signed out.';
      });

      // Navigate back to the splash screen after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacementNamed('/');
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
      appBar: AppBar(title: const Text('Revoke Access Token')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _revokeAccessToken,
              child: const Text('Revoke Access Token and Sign Out'),
            ),
            const SizedBox(height: 16),
            Text(_result, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
