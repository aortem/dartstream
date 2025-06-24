// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';
import '../../shared/shared.dart';
import 'apple_sign_in_view_model.dart';
import 'apple_webview_auth.dart';

/// Screen for handling Apple Sign-In authentication
/// Provides both WebView OAuth flow and manual token input options
class AppleSignInScreen extends StatefulWidget {
  /// Creates an Apple Sign-In screen
  const AppleSignInScreen({super.key});

  @override
  State<AppleSignInScreen> createState() => _AppleSignInScreenState();
}

class _AppleSignInScreenState extends State<AppleSignInScreen> {
  /// Controller for the Apple ID token input field
  final _idTokenController = TextEditingController();

  /// Controller for the optional nonce input field
  final _nonceController = TextEditingController();

  /// View model instance for handling authentication logic
  late AppleSignInViewModel _viewModel;

  /// Loading state flag for UI feedback
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // Initialize the view model with Firebase Auth instance
    _viewModel = AppleSignInViewModel(auth: context.read<FirebaseAuth>());
  }

  /// Handles the Apple Sign-In process using the provided token
  Future<void> _handleSignIn() async {
    if (!mounted) return;
    setState(() => _loading = true);

    try {
      final result = await _viewModel.signInWithApple(
        _idTokenController.text,
        nonce: _nonceController.text.isNotEmpty ? _nonceController.text : null,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed in successfully as ${result.user.email}'),
          backgroundColor: Colors.green,
        ),
      );

      // Optional: Navigate back or to home screen after successful sign-in
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Launches the WebView for Apple Sign-In OAuth flow
  Future<void> _launchWebView() async {
    final idToken = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const AppleWebViewAuth()),
    );

    if (idToken != null && mounted) {
      setState(() {
        _idTokenController.text = idToken;
      });

      // Optional: Automatically trigger sign-in when token is received
      // await _handleSignIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign In with Apple')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // WebView sign-in button
            Button(
              onTap: _launchWebView,
              title: 'Sign In with Apple WebView',
              loading: false,
            ),

            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            // Manual token input section
            const Text(
              'Manual Token Input',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // ID Token input field
            InputField(
              controller: _idTokenController,
              label: 'Apple ID Token',
              hint: 'Enter your Apple ID Token',
            ),
            const SizedBox(height: 16),

            // Optional nonce input field
            InputField(
              controller: _nonceController,
              label: 'Nonce (Optional)',
              hint: 'Enter nonce if available',
            ),
            const SizedBox(height: 24),

            // Manual sign-in button
            Button(
              onTap: _handleSignIn,
              title: 'Sign In with Apple',
              loading: _loading,
            ),

            const SizedBox(height: 24),

            // Information text
            const Text(
              'Note: You can either use the WebView sign-in button above '
              'to get the token automatically, or manually input an Apple '
              'ID token for testing purposes.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers when the screen is disposed
    _idTokenController.dispose();
    _nonceController.dispose();
    super.dispose();
  }
}
