import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:provider/provider.dart';

class GetMultiFactorResolverScreen extends StatefulWidget {
  @override
  _GetMultiFactorResolverScreenState createState() =>
      _GetMultiFactorResolverScreenState();
}

class _GetMultiFactorResolverScreenState
    extends State<GetMultiFactorResolverScreen> {
  String _result = '';
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _getMultiFactorResolver() async {
    try {
      final auth = Provider.of<FirebaseAuth>(context, listen: false);

      try {
        await auth.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        setState(() {
          _result = 'Signed in successfully. No MFA required.';
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'multi-factor-auth-required') {
          // Since we don't have access to a resolver, we'll just show the error message
          setState(() {
            _result = 'MFA Required. Error message: ${e.message}';
          });
          // Here you would typically start the MFA flow, but the exact method
          // will depend on how the SDK implements MFA
        } else {
          setState(() {
            _result = 'Sign-in failed: ${e.message}';
          });
        }
      }
    } catch (e) {
      setState(() {
        _result = 'Error: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Multi-Factor Resolver'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(
              controller: _emailController,
              hint: 'Enter email',
              label: 'Email',
            ),
            SizedBox(height: 10),
            InputField(
              controller: _passwordController,
              hint: 'Enter password',
              label: 'Password',
              obscureText: true,
            ),
            SizedBox(height: 20),
            Button(
              onTap: _getMultiFactorResolver,
              title: 'Get Multi-Factor Resolver',
            ),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
