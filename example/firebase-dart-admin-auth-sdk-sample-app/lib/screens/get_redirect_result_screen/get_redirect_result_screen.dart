import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/shared/shared.dart';
import 'package:firebase_dart_admin_auth_sdk_sample_app/utils/extensions.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GetRedirectResultViewModel extends ChangeNotifier {
  bool _loading = false;
  UserCredential? _result;
  String? _error;
  String _status = '';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly'],
    clientId: 'YOUR_WEB_CLIENT_ID_HERE', //'YOUR_WEB_CLIENT_ID_HERE'
  );

  bool get loading => _loading;
  UserCredential? get result => _result;
  String? get error => _error;
  String get status => _status;

  void setLoading(bool load) {
    _loading = load;
    notifyListeners();
  }

  void setStatus(String newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  Future<void> signInWithGoogleRedirect() async {
    setLoading(true);
    setStatus('Initiating sign-in with Google redirect...');
    try {
      await _googleSignIn.signIn();
      setStatus(
          'Redirect initiated. Complete the sign-in in the opened window.');
    } catch (e) {
      setStatus('Error initiating sign-in: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> getRedirectResult() async {
    setLoading(true);
    _error = null;
    _result = null;
    setStatus('Getting redirect result...');

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _error = 'No redirect result available.';
        setStatus('No redirect result available.');
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final auth = FirebaseApp.instance.getAuth();
      _result =
          (await auth.signInWithCredential(credential)) as UserCredential?;
      setStatus('Redirect result retrieved successfully.');
    } catch (e) {
      _error = e.toString();
      setStatus('Error getting redirect result: $e');
    } finally {
      setLoading(false);
    }
  }
}

class GetRedirectResultScreen extends StatelessWidget {
  const GetRedirectResultScreen({super.key});

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
                  onTap: () => viewModel.signInWithGoogleRedirect(),
                  loading: viewModel.loading,
                  title: 'Sign In with Google Redirect',
                ),
                20.vSpace,
                Button(
                  onTap: () => viewModel.getRedirectResult(),
                  loading: viewModel.loading,
                  title: 'Get Redirect Result',
                ),
                20.vSpace,
                Text('Status: ${viewModel.status}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                20.vSpace,
                if (viewModel.error != null) ...[
                  Text('Error: ${viewModel.error}',
                      style: const TextStyle(color: Colors.red)),
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
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
