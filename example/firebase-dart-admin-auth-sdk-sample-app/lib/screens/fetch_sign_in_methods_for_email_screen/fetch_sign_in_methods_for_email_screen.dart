import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';

class FetchSignInMethodsForEmailScreen extends StatelessWidget {
  const FetchSignInMethodsForEmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();

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
            ),
            SizedBox(height: 20),
            Button(
              onTap: () async {
                try {
                  List<String> methods = await FirebaseApp.firebaseAuth
                          ?.fetchSignInMethodsForEmail(_emailController.text) ??
                      [];
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Sign-in methods: ${methods.join(", ")}')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              title: 'Fetch Sign-In Methods',
            ),
          ],
        ),
      ),
    );
  }
}
