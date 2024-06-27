import 'user_credential.dart';
import 'firebase_auth.dart';
import 'auth_credential.dart';

class ConfirmationResult {
  final String verificationId;
  final FirebaseAuth _auth;

  ConfirmationResult({required this.verificationId, required FirebaseAuth auth})
      : _auth = auth;

  Future<UserCredential> confirm(String verificationCode) async {
    final credential = PhoneAuthCredential(
      verificationId: verificationId,
      smsCode: verificationCode,
    );
    return _auth.signInWithCredential(credential);
  }
}
