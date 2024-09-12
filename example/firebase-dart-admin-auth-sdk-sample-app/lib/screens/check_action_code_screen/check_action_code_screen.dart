import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/check_action_code.dart';

class CheckActionCodeScreen extends StatefulWidget {
  const CheckActionCodeScreen({Key? key}) : super(key: key);

  @override
  _CheckActionCodeScreenState createState() => _CheckActionCodeScreenState();
}

class _CheckActionCodeScreenState extends State<CheckActionCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  ActionCodeInfo? _actionCodeInfo;

  Future<void> _checkActionCode() async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    try {
      final result = await auth.checkActionCode(_codeController.text);
      setState(() {
        _actionCodeInfo = result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to check action code: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Check Action Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Action Code'),
            ),
            ElevatedButton(
              onPressed: _checkActionCode,
              child: Text('Check Action Code'),
            ),
            if (_actionCodeInfo != null) ...[
              Text('Operation: ${_actionCodeInfo!.operation}'),
              Text('Data: ${_actionCodeInfo!.data}'),
            ],
          ],
        ),
      ),
    );
  }
}
