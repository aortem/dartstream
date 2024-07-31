import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';

class GetMultiFactorResolverScreen extends StatelessWidget {
  const GetMultiFactorResolverScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Multi-Factor Resolver'),
      ),
      body: Center(
        child: Button(
          onTap: () async {
            try {
              // Note: This is a simplified example. In a real scenario,
              // you'd get the MultiFactorResolver from a sign-in attempt.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Multi-factor authentication required')),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${e.toString()}')),
              );
            }
          },
          title: 'Simulate Multi-Factor Auth',
        ),
      ),
    );
  }
}
