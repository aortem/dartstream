import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:provider/provider.dart';

class FetchSignInMethodsForEmailScreen extends StatefulWidget {
  const FetchSignInMethodsForEmailScreen({Key? key}) : super(key: key);

  @override
  _FetchSignInMethodsForEmailScreenState createState() =>
      _FetchSignInMethodsForEmailScreenState();
}

class _FetchSignInMethodsForEmailScreenState
    extends State<FetchSignInMethodsForEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Sign-In Methods for Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputField(
              controller: _emailController,
              hint: 'Enter email',
              label: 'Email',
              textInputType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Button(
                    onTap: _fetchSignInMethods,
                    title: 'Fetch Sign-In Methods',
                  ),
            SizedBox(height: 20),
            Text(_result, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _fetchSignInMethods() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    final email = _emailController.text;

    if (email.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      setState(() {
        _result = 'Please enter a valid email address';
        _isLoading = false;
      });
      return;
    }

    try {
      final auth = Provider.of<FirebaseAuth>(context, listen: false);
      List<String> methods = await auth.fetchSignInMethodsForEmail(email);
      setState(() {
        _result = 'Sign-in methods: ${methods.join(", ")}';
      });
    } catch (e) {
      setState(() {
        _result = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
