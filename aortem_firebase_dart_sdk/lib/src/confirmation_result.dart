import 'firebase_auth.dart';
import 'user_credential.dart';
import 'auth_credential.dart';

class ConfirmationResult {
  final String verificationId;
  final FirebaseAuth _auth;

  ConfirmationResult({required this.verificationId, required FirebaseAuth auth})
      : _auth = auth;

  Future<UserCredential> confirm(String smsCode) {
    return _auth.phone.signInWithCredential(
        PhoneAuthCredential(verificationId: verificationId, smsCode: smsCode));
  }
}
