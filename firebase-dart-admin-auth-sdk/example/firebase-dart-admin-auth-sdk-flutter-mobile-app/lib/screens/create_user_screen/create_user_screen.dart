// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase/shared/shared.dart';
import 'package:provider/provider.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create User')),
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
            const SizedBox(height: 10),
            InputField(
              controller: _passwordController,
              hint: 'Enter password',
              label: 'Password',
              obscureText:
                  true, // Make sure InputField widget supports this parameter
            ),
            const SizedBox(height: 20),
            Button(
              onTap: () async {
                try {
                  final auth = Provider.of<FirebaseAuth>(
                    context,
                    listen: false,
                  );
                  UserCredential? credential = await auth
                      .createUserWithEmailAndPassword(
                        _emailController.text,
                        _passwordController.text,
                      );
                  setState(() {
                    _result =
                        'User created: ${credential.user.uid}, Email: ${credential.user.email}';
                  });
                } catch (e) {
                  setState(() {
                    _result = 'Error: ${e.toString()}';
                  });
                }
              },
              title: 'Create User',
            ),
            const SizedBox(height: 20),
            Text(_result, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
