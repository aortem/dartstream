import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/utils/extensions.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class InitializeRecaptchaConfigViewModel extends ChangeNotifier {
  bool loading = false;
  String? result;
  String? errorMessage;

  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> initializeRecaptchaConfig() async {
    try {
      setLoading(true);
      errorMessage = null;
      await FirebaseApp.firebaseAuth?.initializeRecaptchaConfig();
      result = "reCAPTCHA configuration initialized successfully";
    } catch (e) {
      errorMessage = e.toString();
      print('Error: $errorMessage');
    } finally {
      setLoading(false);
    }
  }
}

class InitializeRecaptchaConfigScreen extends StatelessWidget {
  const InitializeRecaptchaConfigScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => InitializeRecaptchaConfigViewModel(),
      child: Consumer<InitializeRecaptchaConfigViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Initialize reCAPTCHA Config'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Button(
                  onTap: () => viewModel.initializeRecaptchaConfig(),
                  loading: viewModel.loading,
                  title: 'Initialize reCAPTCHA Config',
                ),
                20.vSpace,
                if (viewModel.errorMessage != null) ...[
                  Text('Error: ${viewModel.errorMessage}',
                      style: TextStyle(color: Colors.red)),
                ] else if (viewModel.result != null) ...[
                  Text(viewModel.result!),
                ] else if (!viewModel.loading) ...[
                  Text('reCAPTCHA configuration not initialized yet.'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
