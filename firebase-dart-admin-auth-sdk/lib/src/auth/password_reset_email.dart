import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';

class PasswordResetEmailService {
  final FirebaseAuth _auth;

  PasswordResetEmailService({required FirebaseAuth auth}) : _auth = auth;

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.performRequest('sendOobCode', {
      'requestType': 'PASSWORD_RESET',
      'email': email,
    });
  }
}
