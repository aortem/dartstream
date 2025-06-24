// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class AuthStateTestScreen extends StatefulWidget {
  final FirebaseAuth auth;

  const AuthStateTestScreen({super.key, required this.auth});

  @override
  _AuthStateTestScreenState createState() => _AuthStateTestScreenState();
}

class _AuthStateTestScreenState extends State<AuthStateTestScreen> {
  User? _currentUser;
  String _authStateStatus = 'Monitoring auth state...';
  late StreamSubscription<User?> _subscription;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.auth.currentUser;
    _setupAuthStateListener();
  }

  void _setupAuthStateListener() {
    _subscription = widget.auth.onAuthStateChanged().listen(
      (User? user) {
        setState(() {
          _currentUser = user;
          _authStateStatus = user != null
              ? 'User signed in: ${user.email ?? user.uid}'
              : 'No user signed in';
        });
      },
      onError: (error) {
        setState(() {
          _authStateStatus = 'Error: $error';
        });
      },
    );
  }

  Future<void> _signOut() async {
    try {
      await widget.auth.signOut();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sign out failed: $e')));
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
      appBar: AppBar(title: const Text('Auth State Monitor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Status:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(_authStateStatus),
            const SizedBox(height: 20),
            if (_currentUser != null) ...[
              Text(
                'User Details:',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('UID: ${_currentUser!.uid}'),
              if (_currentUser!.email != null)
                Text('Email: ${_currentUser!.email}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signOut,
                child: const Text('Sign Out'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
