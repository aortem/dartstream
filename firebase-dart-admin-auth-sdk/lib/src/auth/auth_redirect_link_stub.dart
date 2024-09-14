import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

class SignInWithRedirectService {
  final FirebaseAuth auth;

  SignInWithRedirectService({required this.auth});

  Future<void> signInWithRedirect(String providerUrl) async {
    throw UnsupportedError('signInWithRedirect is only supported on the web.');
  }

  Future<Map<String, dynamic>> handleRedirectResult() async {
    throw UnsupportedError('handleRedirectResult is only supported on the web.');
  }
}
