import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';

class GetRedirectResultScreen extends StatefulWidget {
  const GetRedirectResultScreen({super.key});

  @override
  State<GetRedirectResultScreen> createState() =>
      _GetRedirectResultScreenState();
}

class _GetRedirectResultScreenState extends State<GetRedirectResultScreen> {
  Map<String, dynamic>? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    _getRedirectResult();
  }

  Future<void> _getRedirectResult() async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    try {
      final result = await auth.getRedirectResult();
      setState(() {
        _result = result;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _result = null;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Get Redirect Result')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _getRedirectResult,
              child: const Text('Get Redirect Result'),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text('Error: $_error', style: const TextStyle(color: Colors.red)),
            if (_result != null) ...[
              Text('User ID: ${_result!['user']?['uid']}'),
              Text('Email: ${_result!['user']?['email']}'),
              Text('Display Name: ${_result!['user']?['displayName']}'),
              Text('Provider ID: ${_result!['credential']?['providerId']}'),
              Text(
                  'Is New User: ${_result!['additionalUserInfo']?['isNewUser']}'),
            ],
          ],
        ),
      ),
    );
  }
}
