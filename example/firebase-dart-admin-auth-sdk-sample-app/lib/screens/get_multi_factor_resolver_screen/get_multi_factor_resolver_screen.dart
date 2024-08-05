import 'dart:convert';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:provider/provider.dart';
import 'package:ds_standard_features/ds_standard_features.dart' as http;

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
          setState(() {
            _result = 'MFA Required. Error message: ${e.message}';
          });

          // Create an EmailAuthCredential
          final credential = EmailAuthCredential(
            email: _emailController.text,
            password: _passwordController.text,
          );

          // Get the MultiFactorResolver
          final resolver = await auth.getMultiFactorResolver(credential);

          // Display MFA options to the user
          _showMfaOptions(resolver);
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

  void _showMfaOptions(MultiFactorResolver resolver) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select MFA Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: resolver.hints.map((hint) {
              return ListTile(
                title: Text(hint.displayName),
                onTap: () {
                  Navigator.of(context).pop();
                  _startMfaFlow(resolver, hint);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _startMfaFlow(
      MultiFactorResolver resolver, MultiFactorHint hint) async {
    setState(() {
      _result = 'Starting MFA flow for ${hint.displayName}';
    });

    try {
      // Prompt user to enter the verification code
      final verificationCode = await _promptForVerificationCode();

      // Complete the MFA sign-in process
      await _completeMfaSignIn(
          resolver.sessionId, hint.factorId, verificationCode);

      setState(() {
        _result = 'MFA completed successfully.';
      });
    } catch (e) {
      setState(() {
        _result = 'MFA failed: ${e.toString()}';
      });
    }
  }

  Future<void> _completeMfaSignIn(
      String sessionId, String factorId, String verificationCode) async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:signInWithPhoneNumber',
      {'key': auth.apiKey},
    );

    final response = await http.post(
      url,
      body: json.encode({
        'sessionInfo': sessionId,
        'phoneNumber': factorId,
        'code': verificationCode,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw FirebaseAuthException(
        code: 'mfa-completion-failed',
        message: 'Failed to complete MFA: ${response.body}',
      );
    }

    final responseData = json.decode(response.body);
    final idToken = responseData['idToken'];

    // Update the user's ID token in your app's state
    await auth.setIdToken(idToken);
  }

  Future<String> _promptForVerificationCode() async {
    String verificationCode = '';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Verification Code'),
          content: TextField(
            onChanged: (value) {
              verificationCode = value;
            },
            decoration: InputDecoration(
              hintText: 'Verification Code',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );

    return verificationCode;
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
