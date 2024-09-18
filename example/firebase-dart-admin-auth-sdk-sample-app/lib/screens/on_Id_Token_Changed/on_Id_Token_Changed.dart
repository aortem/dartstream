import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

// Define Unsubscribe type if it's not imported from the SDK
typedef Unsubscribe = void Function();

class OnIdTokenChangedScreen extends StatefulWidget {
  final FirebaseAuth auth;

  OnIdTokenChangedScreen({Key? key, required this.auth}) : super(key: key);

  @override
  _OnIdTokenChangedScreenState createState() => _OnIdTokenChangedScreenState();
}

class _OnIdTokenChangedScreenState extends State<OnIdTokenChangedScreen> {
  String _lastIdTokenChange = 'No changes yet';
  late Unsubscribe _unsubscribe;

  @override
  void initState() {
    super.initState();
    _setupIdTokenListener();
  }

  void _setupIdTokenListener() {
    _unsubscribe = widget.auth.onIdTokenChanged(
      (User? user) {
        setState(() {
          if (user != null) {
            _lastIdTokenChange = 'ID token changed for user: ${user.uid}';
          } else {
            _lastIdTokenChange = 'User signed out';
          }
        });
      },
      error: (FirebaseAuthException error, StackTrace? stackTrace) {
        setState(() {
          _lastIdTokenChange = 'Error: ${error.message}';
        });
      },
    );
  }

  Future<void> _refreshIdToken() async {
    setState(() {
      _lastIdTokenChange = 'Refreshing ID token...';
    });

    try {
      final user = widget.auth.currentUser;
      if (user != null) {
        final token = await user.getIdToken(true);
        setState(() {
          _lastIdTokenChange = 'Token refreshed: ${token.substring(0, 10)}...';
        });
      } else {
        setState(() {
          _lastIdTokenChange = 'No user signed in to refresh token';
        });
      }
    } catch (e) {
      setState(() {
        _lastIdTokenChange = 'Error refreshing token: $e';
      });
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('onIdTokenChanged Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Current User ID: ${widget.auth.currentUser?.uid ?? 'Not signed in'}'),
            SizedBox(height: 20),
            Text('Last ID Token Change:'),
            Text(_lastIdTokenChange,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _refreshIdToken,
              child: Text('Refresh ID Token'),
            ),
          ],
        ),
      ),
    );
  }
}
