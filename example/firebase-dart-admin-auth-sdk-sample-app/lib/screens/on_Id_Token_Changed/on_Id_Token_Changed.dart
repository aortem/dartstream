import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class TestScreen extends StatefulWidget {
  final FirebaseAuth auth;

  TestScreen({Key? key, required this.auth}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  StreamSubscription<User?>? _idTokenSubscription;
  String _lastIdTokenChange = 'No changes yet';

  @override
  void initState() {
    super.initState();
    _idTokenSubscription = widget.auth.onIdTokenChanged().listen((User? user) {
      setState(() {
        _lastIdTokenChange = user != null
            ? 'ID token changed for user: ${user.uid}'
            : 'User signed out';
      });
    });
  }

  @override
  void dispose() {
    _idTokenSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ID Token Change Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Last ID Token Change:'),
            Text(_lastIdTokenChange,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Simulate an ID token change
                User mockUser =
                    User(uid: 'mock_user_id', email: 'mock@example.com');
                widget.auth.updateCurrentUser(mockUser);
              },
              child: Text('Simulate ID Token Change'),
            ),
          ],
        ),
      ),
    );
  }
}
