import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';

class VerifyIdTokenScreen extends StatefulWidget {
  const VerifyIdTokenScreen({super.key});

  @override
  State<VerifyIdTokenScreen> createState() => _VerifyIdTokenScreenState();
}

class _VerifyIdTokenScreenState extends State<VerifyIdTokenScreen> {
  final _tokenController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _verifiedData;

  Future<void> _verifyToken() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _verifiedData = null;
    });

    try {
      final auth = Provider.of<FirebaseAuth>(context, listen: false);
      final verifiedData = await auth.verifyIdToken(_tokenController.text);

      setState(() {
        _verifiedData = verifiedData;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify ID Token')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: 'Firebase ID Token',
                hintText: 'Enter the token to verify',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _verifyToken,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Verify Token'),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            if (_verifiedData != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Verified Token Data:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow('User ID', _verifiedData!['localId']),
                      _buildInfoRow('Email', _verifiedData!['email']),
                      _buildInfoRow(
                        'Display Name',
                        _verifiedData!['displayName'],
                      ),
                      _buildInfoRow(
                        'Email Verified',
                        _verifiedData!['emailVerified'].toString(),
                      ),
                      _buildInfoRow('Created At', _verifiedData!['createdAt']),
                      _buildInfoRow(
                        'Last Login',
                        _verifiedData!['lastLoginAt'],
                      ),
                      if (_verifiedData!['phoneNumber']?.isNotEmpty ?? false)
                        _buildInfoRow(
                          'Phone Number',
                          _verifiedData!['phoneNumber'],
                        ),
                      const SizedBox(height: 8),
                      if (_verifiedData!['providerUserInfo'].isNotEmpty) ...[
                        const Text(
                          'Linked Providers:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var provider
                                in _verifiedData!['providerUserInfo'])
                              Text('- ${provider['providerId']}'),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }
}
