import 'package:flutter/material.dart';
import 'package:ds_auth_base/ds_auth_base_export.dart';

class HomeScreen extends StatelessWidget {
  final DSAuthUser user;
  final DSAuthManager authManager;

  const HomeScreen({
    super.key,
    required this.user,
    required this.authManager,
  });

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      await authManager.signOut();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e is DSAuthError ? e.message : e.toString(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DartStream Auth Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleSignOut(context),
          ),
        ],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Authentication Successful!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _UserInfoRow(
                    label: 'User ID:',
                    value: user.id,
                  ),
                  const SizedBox(height: 8),
                  _UserInfoRow(
                    label: 'Email:',
                    value: user.email,
                  ),
                  const SizedBox(height: 8),
                  _UserInfoRow(
                    label: 'Display Name:',
                    value: user.displayName,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => _handleSignOut(context),
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UserInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _UserInfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(value, softWrap: true),
        ),
      ],
    );
  }
}
