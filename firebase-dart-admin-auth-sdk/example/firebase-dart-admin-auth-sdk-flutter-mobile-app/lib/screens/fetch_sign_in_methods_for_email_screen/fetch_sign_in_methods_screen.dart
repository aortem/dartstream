// ignore_for_file: library_private_types_in_public_api

import 'package:firebase/screens/fetch_sign_in_methods_for_email_screen/fetch_sign_in_methods_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase/shared/shared.dart';
import 'package:firebase/utils/extensions.dart';

class FetchSignInMethodsScreen extends StatefulWidget {
  const FetchSignInMethodsScreen({super.key});

  @override
  _FetchSignInMethodsScreenState createState() =>
      _FetchSignInMethodsScreenState();
}

class _FetchSignInMethodsScreenState extends State<FetchSignInMethodsScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FetchSignInMethodsViewModel(),
      child: Consumer<FetchSignInMethodsViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Fetch Sign-In Methods'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InputField(
                  controller: _emailController,
                  label: 'Email',
                ),
                20.vSpace,
                Button(
                  onTap: () =>
                      viewModel.fetchSignInMethods(_emailController.text),
                  loading: viewModel.loading,
                  title: 'Fetch Sign-In Methods',
                ),
                20.vSpace,
                if (viewModel.result != null) ...[
                  Text('Sign-In Methods: ${viewModel.result!.join(", ")}'),
                ] else if (!viewModel.loading) ...[
                  const Text('No sign-in methods found or not fetched yet.'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
