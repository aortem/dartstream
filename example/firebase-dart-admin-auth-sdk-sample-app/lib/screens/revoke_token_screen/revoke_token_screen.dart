import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class RevokeTokenScreen extends StatefulWidget {
  final FirebaseAuth auth;

  const RevokeTokenScreen({Key? key, required this.auth}) : super(key: key);

  @override
  _RevokeTokenScreenState createState() => _RevokeTokenScreenState();
}

class _RevokeTokenScreenState extends State<RevokeTokenScreen> {
  final TextEditingController _tokenController = TextEditingController();
  String _result = '';

  Future<void> _revokeToken() async {
    setState(() {
      _result = 'Revoking token...';
    });

    try {
      await widget.auth.revokeToken(_tokenController.text);
      setState(() {
        _result = 'Token revoked successfully';
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
      appBar: AppBar(
        title: Text('Revoke Token'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tokenController,
              decoration: InputDecoration(
                labelText: 'ID Token',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _revokeToken,
              child: Text('Revoke Token'),
            ),
            SizedBox(height: 16),
            Text(_result),
          ],
        ),
      ),
    );
  }
}
