import 'package:firebase_dart_admin_auth_sdk_sample_app/screens/fetch_sign_in_methods_for_email_screen/fetch_sign_in_methods_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/utils/extensions.dart';

class FetchSignInMethodsScreen extends StatefulWidget {
  const FetchSignInMethodsScreen({Key? key}) : super(key: key);

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
                  Text('No sign-in methods found or not fetched yet.'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
