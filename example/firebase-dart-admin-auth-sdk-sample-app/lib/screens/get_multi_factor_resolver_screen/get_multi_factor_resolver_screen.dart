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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();
  String _result = '';

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

  Future<void> _getMultiFactorResolver() async {
    setState(() {
      _result = 'Attempting to sign in...';
    });

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
          final resolver =
              await auth.getMultiFactorResolver(EmailAuthCredential(
            email: _emailController.text,
            password: _passwordController.text,
          ));

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
                subtitle: Text(hint.factorId),
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
      _result = 'Starting MFA flow...';
    });

    try {
      if (hint.factorId == 'phone') {
        await _handlePhoneMfa(resolver, hint);
      } else {
        throw Exception('Unsupported MFA method');
      }
    } catch (e) {
      setState(() {
        _result = 'MFA Error: ${e.toString()}';
      });
    }
  }

  Future<void> _handlePhoneMfa(
      MultiFactorResolver resolver, MultiFactorHint hint) async {
    final auth = Provider.of<FirebaseAuth>(context, listen: false);

    // Send the SMS code
    await auth.verifyPhoneNumber(
      phoneNumber: (hint is PhoneMultiFactorHint) ? hint.phoneNumber : '',
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _finalizeMfa(resolver, credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _result = 'Phone verification failed: ${e.message}';
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        _showSmsCodeDialog(resolver, verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval timeout
      },
    );
  }

  void _showSmsCodeDialog(MultiFactorResolver resolver, String verificationId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter SMS Code'),
          content: TextField(
            controller: _verificationCodeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'SMS Code'),
          ),
          actions: [
            TextButton(
              child: Text('Submit'),
              onPressed: () async {
                Navigator.of(context).pop();
                final credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: _verificationCodeController.text,
                );
                await _finalizeMfa(resolver, credential);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _finalizeMfa(
      MultiFactorResolver resolver, AuthCredential credential) async {
    try {
      final userCredential = await resolver.resolveSignIn(credential);

      setState(() {
        _result =
            'MFA completed successfully. Signed in as: ${userCredential.user?.email}';
      });
    } catch (e) {
      setState(() {
        _result = 'MFA completion failed: ${e.toString()}';
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _verificationCodeController.dispose();
    super.dispose();
  }
}
