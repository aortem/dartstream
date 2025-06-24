import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';

class CheckActionCodeScreen extends StatefulWidget {
  const CheckActionCodeScreen({super.key});

  @override
  State<CheckActionCodeScreen> createState() => _CheckActionCodeScreenState();
}

class _CheckActionCodeScreenState extends State<CheckActionCodeScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  ActionCodeInfo? _actionCodeInfo;
  String _status = '';

  Future<void> _sendPasswordResetEmail() async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    try {
      await auth.sendPasswordResetEmail(_emailController.text);
      setState(() {
        _status = 'Password reset email sent. Check your inbox for the link.';
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to send password reset email: $e';
      });
    }
  }

  Future<void> _checkActionCode() async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    try {
      // Parse the URL to extract the oobCode
      final uri = Uri.parse(_linkController.text);
      final oobCode = uri.queryParameters['oobCode'];

      if (oobCode == null) {
        throw Exception('Invalid reset password link');
      }

      final result = await auth.checkActionCode(oobCode);
      setState(() {
        _actionCodeInfo = result;
        _status =
            'Action code checked successfully. You can now reset your password.';
      });
    } catch (e) {
      setState(() {
        _actionCodeInfo = null;
        _status = 'Failed to check action code: $e';
      });
    }
  }

  Future<void> _resetPassword() async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    try {
      final uri = Uri.parse(_linkController.text);
      final oobCode = uri.queryParameters['oobCode'];

      if (oobCode == null) {
        throw Exception('Invalid reset password link');
      }

      await auth.confirmPasswordReset(oobCode, _newPasswordController.text);
      setState(() {
        _status = 'Password reset successfully.';
        _actionCodeInfo = null;
      });
    } catch (e) {
      setState(() {
        _status = 'Failed to reset password: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Check Action Code')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _sendPasswordResetEmail,
              child: const Text('Send Password Reset Email'),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _linkController,
              decoration: const InputDecoration(
                labelText: 'Password Reset Link',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkActionCode,
              child: const Text('Check Action Code'),
            ),
            if (_actionCodeInfo != null &&
                _actionCodeInfo!.operation == 'PASSWORD_RESET') ...[
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                decoration: const InputDecoration(labelText: 'New Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _resetPassword,
                child: const Text('Reset Password'),
              ),
            ],
            const SizedBox(height: 16),
            Text(_status, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (_actionCodeInfo != null) ...[
              const SizedBox(height: 16),
              Text('Operation: ${_actionCodeInfo!.operation}'),
              Text('Email: ${_actionCodeInfo!.data['email'] ?? 'N/A'}'),
            ],
          ],
        ),
      ),
    );
  }
}
