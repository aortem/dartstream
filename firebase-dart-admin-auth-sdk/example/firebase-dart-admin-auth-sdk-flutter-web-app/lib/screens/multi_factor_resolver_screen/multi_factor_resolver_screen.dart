// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/get_multi_factor.dart'
    as multi_factor;

class MultiFactorResolverScreen extends StatefulWidget {
  const MultiFactorResolverScreen({super.key});

  @override
  MultiFactorResolverScreenState createState() =>
      MultiFactorResolverScreenState();
}

class MultiFactorResolverScreenState extends State<MultiFactorResolverScreen> {
  multi_factor.MultiFactorResolver? resolver;

  Future<void> getMultiFactorResolver() async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    try {
      final mockError = multi_factor.MultiFactorError(
        hints: [
          multi_factor.MultiFactorInfo(factorId: 'phone', displayName: 'Phone'),
        ],
        session: multi_factor.MultiFactorSession(id: 'mock-session-id'),
      );
      final obtainedResolver = await auth.getMultiFactorResolver(mockError);
      setState(() {
        resolver = obtainedResolver;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to get multi-factor resolver: $e')),
      );
    }
  }

  Future<void> resolveSignIn() async {
    if (resolver == null) return;

    try {
      final mockAssertion = multi_factor.MultiFactorAssertion(
        factorId: 'phone',
        secret: '123456',
      );
      final userCredential = await resolver!.resolveSignIn(mockAssertion);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed in as: ${userCredential.user?.email}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to resolve sign-in: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi-Factor Resolver')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: getMultiFactorResolver,
              child: const Text('Get Multi-Factor Resolver'),
            ),
            if (resolver != null) ...[
              const SizedBox(height: 20),
              const Text('Resolver obtained. Hints:'),
              ...resolver!.hints.map((hint) => Text(hint.displayName)),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: resolveSignIn,
                child: const Text('Resolve Sign-In'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
