import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/auth_state_changed.dart'
    as auth_state;

class AuthStateTestScreen extends StatefulWidget {
  final FirebaseAuth auth;

  AuthStateTestScreen({Key? key, required this.auth}) : super(key: key);

  @override
  _AuthStateTestScreenState createState() => _AuthStateTestScreenState();
}

class _AuthStateTestScreenState extends State<AuthStateTestScreen> {
  User? _currentUser;
  late auth_state.Unsubscribe _unsubscribe;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.auth.currentUser;
    _unsubscribe = widget.auth.onAuthStateChanged(
      (User? user) {
        print("Auth state changed. User: ${user?.email ?? 'null'}");
        setState(() {
          _currentUser = user;
        });
      },
      error: (Object error, StackTrace? stackTrace) {
        print('Auth state change error: $error');
        if (stackTrace != null) {
          print('Stack trace: $stackTrace');
        }
      },
      completed: () {
        print('Auth state change stream completed');
      },
    );
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  Future<void> _signOut() async {
    try {
      await widget.auth.signOut();
      print('User signed out successfully');
      setState(() {
        _currentUser = null;
      });
    } catch (e) {
      print('Sign out failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed: $e')),
      );
    }
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
                  : 'This user: ${_currentUser!.email} is signed in',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            if (_currentUser != null)
              ElevatedButton(
                onPressed: _signOut,
                child: Text('Sign Out'),
              ),
          ],
        ),
      ),
    );
  }
}
