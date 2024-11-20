import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';
import '../../shared/shared.dart';
import 'apple_sign_in_view_model.dart';

class AppleSignInScreen extends StatefulWidget {
  const AppleSignInScreen({super.key});

  @override
  State<AppleSignInScreen> createState() => _AppleSignInScreenState();
}

class _AppleSignInScreenState extends State<AppleSignInScreen> {
  final _idTokenController = TextEditingController();
  final _nonceController = TextEditingController();
  late AppleSignInViewModel _viewModel;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _viewModel = AppleSignInViewModel(
      auth: context.read<FirebaseAuth>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In with Apple'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputField(
              controller: _idTokenController,
              label: 'Apple ID Token',
              hint: 'Enter your Apple ID Token',
            ),
            const SizedBox(height: 16),
            InputField(
              controller: _nonceController,
              label: 'Nonce (Optional)',
              hint: 'Enter nonce if available',
            ),
            const SizedBox(height: 24),
            Button(
              onTap: () async {
                if (!mounted) return;
                setState(() => _loading = true);
                try {
                  final result = await _viewModel.signInWithApple(
                    _idTokenController.text,
                    nonce: _nonceController.text.isNotEmpty
                        ? _nonceController.text
                        : null,
                  );
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Signed in successfully as ${result.user.email}'),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                } finally {
                  if (mounted) setState(() => _loading = false);
                }
              },
              title: 'Sign In with Apple',
              loading: _loading,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idTokenController.dispose();
    _nonceController.dispose();
    super.dispose();
  }
}
