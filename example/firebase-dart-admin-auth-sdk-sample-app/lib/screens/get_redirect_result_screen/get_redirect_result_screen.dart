import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/utils/extensions.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

class GetRedirectResultViewModel extends ChangeNotifier {
  bool _loading = false;
  UserCredential? _result;
  String? _error;

  bool get loading => _loading;
  UserCredential? get result => _result;
  String? get error => _error;

  void setLoading(bool load) {
    _loading = load;
    notifyListeners();
  }

  Future<void> getRedirectResult() async {
    setLoading(true);
    _error = null;
    _result = null;

    try {
      _result = await FirebaseApp.instance.getAuth().getRedirectResult();
      if (_result == null) {
        _error = 'No redirect result available.';
      }
    } catch (e) {
      _error = e.toString();
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
                if (viewModel.error != null) ...[
                  Text('Error: ${viewModel.error}',
                      style: TextStyle(color: Colors.red)),
                ] else if (viewModel.result != null) ...[
                  Text('User ID: ${viewModel.result!.user.uid}'),
                  Text('Email: ${viewModel.result!.user.email ?? 'N/A'}'),
                  Text(
                      'Display Name: ${viewModel.result!.user.displayName ?? 'N/A'}'),
                  Text(
                      'Provider ID: ${viewModel.result!.additionalUserInfo?.providerId ?? 'N/A'}'),
                  Text(
                      'Is New User: ${viewModel.result!.additionalUserInfo?.isNewUser ?? 'N/A'}'),
                  if (viewModel.result!.credential is OAuthCredential)
                    Text(
                        'Access Token: ${(viewModel.result!.credential as OAuthCredential).accessToken ?? 'N/A'}'),
                ] else if (!viewModel.loading) ...[
                  Text(
                      'No redirect result available. Try signing in with a redirect method first.'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
