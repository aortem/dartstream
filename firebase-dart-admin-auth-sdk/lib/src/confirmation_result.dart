import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';

class ConfirmationResult {
  final String verificationId;
  final FirebaseAuth _auth;

  ConfirmationResult({required this.verificationId, required FirebaseAuth auth})
      : _auth = auth;

  Future<UserCredential> confirm(String verificationCode) async {
    return await _auth.phone
        .confirmPhoneNumber(verificationId, verificationCode);
  }
}
