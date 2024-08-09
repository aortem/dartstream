import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class AuthStateTestScreen extends StatefulWidget {
  final FirebaseAuth auth;

  AuthStateTestScreen({Key? key, required this.auth}) : super(key: key);

  @override
  _AuthStateTestScreenState createState() => _AuthStateTestScreenState();
}

class _AuthStateTestScreenState extends State<AuthStateTestScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    widget.auth.onAuthStateChanged().listen((User? user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth State Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _currentUser == null
                  ? 'No user is currently signed in.'
                  : 'Current user: ${_currentUser!.email}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  await widget.auth.signInWithEmailAndPassword(
                    'test@example.com',
                    'password123',
                  );
                } catch (e) {
                  print('Sign in failed: $e');
                }
              },
              child: Text('Sign In'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                try {
                  await widget.auth.signOut();
                } catch (e) {
                  print('Sign out failed: $e');
                }
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
