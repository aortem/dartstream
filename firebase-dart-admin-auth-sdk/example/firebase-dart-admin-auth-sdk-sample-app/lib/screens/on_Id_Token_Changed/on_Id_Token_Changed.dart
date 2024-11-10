import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class IdTokenChangedScreen extends StatefulWidget {
  final FirebaseAuth auth;

  const IdTokenChangedScreen({Key? key, required this.auth}) : super(key: key);

  @override
  _IdTokenChangedScreenState createState() => _IdTokenChangedScreenState();
}

class _IdTokenChangedScreenState extends State<IdTokenChangedScreen> {
  String _tokenStatus = 'Monitoring ID token...';
  late StreamSubscription<User?> _subscription;
  DateTime? _lastTokenUpdate;

  @override
  void initState() {
    super.initState();
    _setupIdTokenListener();
  }

  void _setupIdTokenListener() {
    _subscription = widget.auth.onIdTokenChanged().listen(
      (User? user) {
        setState(() {
          _lastTokenUpdate = DateTime.now();
          _tokenStatus = user != null
              ? 'Token updated for user: ${user.email ?? user.uid}'
              : 'No active token';
        });
      },
      onError: (error) {
        setState(() {
          _tokenStatus = 'Error: $error';
        });
      },
    );
  }

  Future<void> _refreshToken() async {
    final user = widget.auth.currentUser;
    if (user != null) {
      try {
        await user.getIdToken(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token refresh requested')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Token refresh failed: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user signed in')),
      );
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ID Token Monitor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Token Status:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8),
            Text(_tokenStatus),
            if (_lastTokenUpdate != null) ...[
              SizedBox(height: 8),
              Text('Last Updated: ${_lastTokenUpdate!.toString()}'),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _refreshToken,
              child: Text('Refresh Token'),
            ),
          ],
        ),
      ),
    );
  }
}
