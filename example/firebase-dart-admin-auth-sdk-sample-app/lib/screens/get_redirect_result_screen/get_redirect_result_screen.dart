import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/utils/extensions.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class GetRedirectResultViewModel extends ChangeNotifier {
  bool loading = false;
  UserCredential? result;

  void setLoading(bool load) {
    loading = load;
    notifyListeners();
  }

  Future<void> getRedirectResult() async {
    try {
      setLoading(true);
      result = await FirebaseApp.firebaseAuth?.getRedirectResult();
      notifyListeners();
    } catch (e) {
      // Use your preferred method to show errors, e.g., BotToast
      print('Error: ${e.toString()}');
    } finally {
      setLoading(false);
    }
  }
}

class GetRedirectResultScreen extends StatelessWidget {
  const GetRedirectResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GetRedirectResultViewModel(),
      child: Consumer<GetRedirectResultViewModel>(
        builder: (context, viewModel, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Get Redirect Result'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Button(
                  onTap: () => viewModel.getRedirectResult(),
                  loading: viewModel.loading,
                  title: 'Get Redirect Result',
                ),
                20.vSpace,
                if (viewModel.result != null) ...[
                  Text('User ID: ${viewModel.result!.user?.uid ?? 'N/A'}'),
                  Text('Email: ${viewModel.result!.user?.email ?? 'N/A'}'),
                  Text(
                      'Display Name: ${viewModel.result!.user?.displayName ?? 'N/A'}'),
                  // Add more user properties as needed
                ] else if (!viewModel.loading) ...[
                  Text('No redirect result available or not fetched yet.'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
