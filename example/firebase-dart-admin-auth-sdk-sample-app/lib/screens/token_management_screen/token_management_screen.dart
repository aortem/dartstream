import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class TokenManagementScreen extends StatefulWidget {
  @override
  _TokenManagementScreenState createState() => _TokenManagementScreenState();
}

class _TokenManagementScreenState extends State<TokenManagementScreen> {
  String? _currentIdToken;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _setupStreams();
  }

  void _setupStreams() {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    auth.onIdTokenChanged().listen((User? user) {
      setState(() {
        _currentUser = user;
        _currentIdToken = user?.getIdToken() as String?;
      });
      print('ID Token changed: ${user?.getIdToken()}');
    });

    auth.onAuthStateChanged().listen((User? user) {
      print('Auth State changed: ${user?.uid}');
    });
  }

  Future<void> _revokeToken() async {
    if (_currentIdToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No token available to revoke')),
      );
      return;
    }

    try {
      final auth = Provider.of<FirebaseAuth>(context, listen: false);
      await auth.revokeToken(_currentIdToken!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token revoked successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to revoke token: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Token Management')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Current User: ${_currentUser?.uid ?? 'None'}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _revokeToken,
              child: Text('Revoke Current Token'),
            ),
          ],
        ),
      ),
    );
  }
}
