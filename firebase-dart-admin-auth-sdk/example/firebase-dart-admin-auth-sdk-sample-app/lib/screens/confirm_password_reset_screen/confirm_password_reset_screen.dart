import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';

class ConfirmPasswordResetScreen extends StatefulWidget {
  const ConfirmPasswordResetScreen({Key? key}) : super(key: key);

  @override
  _ConfirmPasswordResetScreenState createState() =>
      _ConfirmPasswordResetScreenState();
}

class _ConfirmPasswordResetScreenState
    extends State<ConfirmPasswordResetScreen> {
  final TextEditingController _resetLinkController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  Future<void> _confirmPasswordReset() async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    try {
      String oobCode = _extractOobCode(_resetLinkController.text);
      await auth.confirmPasswordReset(oobCode, _newPasswordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset confirmed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to confirm password reset: $e')),
      );
    }
  }

  String _extractOobCode(String resetLink) {
    Uri uri = Uri.parse(resetLink);
    return uri.queryParameters['oobCode'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Confirm Password Reset')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _resetLinkController,
              decoration: InputDecoration(labelText: 'Reset Link'),
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: _confirmPasswordReset,
              child: Text('Confirm Password Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
