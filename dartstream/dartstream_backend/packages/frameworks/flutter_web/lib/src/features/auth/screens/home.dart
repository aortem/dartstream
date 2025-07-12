import 'package:flutter/material.dart';
import 'package:# ds_auth_base/# ds_auth_base_export.dart';

class HomeScreen extends StatelessWidget {
  final DSAuthUser user;
  final DSAuthManager authManager;
  final VoidCallback onSignOut;

  const HomeScreen({
    super.key,
    required this.user,
    required this.authManager,
    required this.onSignOut,
  });

  Future<void> _handleSignOut(BuildContext context) async {
    try {
      await authManager.signOut();
      onSignOut();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e is DSAuthError ? e.message : e.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
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
            tooltip: 'Sign Out',
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Authentication Successful!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  _UserInfoRow(label: 'User ID:', value: user.id),
                  const SizedBox(height: 8),
                  _UserInfoRow(label: 'Email:', value: user.email),
                  const SizedBox(height: 8),
                  _UserInfoRow(label: 'Display Name:', value: user.displayName),
                  if (user.customAttributes != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Custom Attributes:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...user.customAttributes!.entries.map(
                      (entry) => _UserInfoRow(
                        label: '${entry.key}:',
                        value: entry.value.toString(),
                      ),
                    ),
                  ],
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

  const _UserInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Expanded(child: Text(value, softWrap: true)),
      ],
    );
  }
}
