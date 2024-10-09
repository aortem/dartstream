import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sign_in_with_popup_view_model.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class SignInWithPopupScreen extends StatelessWidget {
  const SignInWithPopupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          SignInWithPopupViewModel(context.read<FirebaseAuth>()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Sign In with Popup')),
        body: Center(
          child: Consumer<SignInWithPopupViewModel>(
            builder: (context, model, child) {
              if (model.isLoading) {
                return const CircularProgressIndicator();
              } else if (model.user != null) {
                return Text('Signed in as: ${model.user!.email}');
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: model.signInWithGoogle,
                      child: const Text('Sign in with Google'),
                    ),
                    const SizedBox(height: 16),
                    if (model.errorMessage != null)
                      Text(
                        model.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
