import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';

class SignInWithCustomTokenScreen extends StatefulWidget {
  const SignInWithCustomTokenScreen({Key? key}) : super(key: key);

  @override
  _SignInWithCustomTokenScreenState createState() =>
      _SignInWithCustomTokenScreenState();
}

class _SignInWithCustomTokenScreenState
    extends State<SignInWithCustomTokenScreen> {
  final TextEditingController _uidController = TextEditingController();
  bool _isLoading = false;
  bool _useCustomUid = false;

  String _generateRandomUid() {
    // Generate a timestamp-based random UID
    return 'user_${DateTime.now().millisecondsSinceEpoch}_${(1000 + Random().nextInt(9000))}';
  }

  @override
  void initState() {
    super.initState();
    // Generate initial random UID
    _uidController.text = _generateRandomUid();
  }

  Future<void> _handleSignIn() async {
    final uid =
        _useCustomUid ? _uidController.text.trim() : _generateRandomUid();

    if (uid.isEmpty) {
      _showError('Error', 'Please enter a UID or use auto-generated one');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = Provider.of<FirebaseAuth>(context, listen: false);

      // Using the implemented signInWithCustomToken method
      final userCredential = await auth.signInWithCustomToken(uid);

      BotToast.showText(
        text:
            'Successfully signed in with custom token\nUID: ${userCredential.user.uid}',
        duration: const Duration(seconds: 3),
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      _showError('Authentication Failed', e.message ?? 'An error occurred');
    } catch (e) {
      _showError('Error', 'An unexpected error occurred: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In with Custom Token'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Custom Token Authentication',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Test authentication using either an auto-generated UID or provide your own.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Switch for custom/auto UID
            Card(
              child: SwitchListTile(
                title: const Text('Use Custom UID'),
                subtitle: Text(_useCustomUid
                    ? 'Enter your own UID'
                    : 'Using auto-generated UID'),
                value: _useCustomUid,
                onChanged: _isLoading
                    ? null
                    : (value) {
                        setState(() {
                          _useCustomUid = value;
                          if (!value) {
                            _uidController.text = _generateRandomUid();
                          }
                        });
                      },
              ),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: _uidController,
              decoration: InputDecoration(
                labelText:
                    _useCustomUid ? 'Enter Custom UID' : 'Auto-generated UID',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person_outline),
                suffixIcon: _useCustomUid
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _uidController.text = _generateRandomUid();
                                });
                              },
                        tooltip: 'Generate new UID',
                      ),
              ),
              enabled: _useCustomUid && !_isLoading,
              readOnly: !_useCustomUid,
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isLoading ? null : _handleSignIn,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Sign In with Custom Token'),
              ),
            ),

            if (_isLoading) ...[
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Generating token and signing in...',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Display current UID
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current UID:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _uidController.text,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _uidController.dispose();
    super.dispose();
  }
}
