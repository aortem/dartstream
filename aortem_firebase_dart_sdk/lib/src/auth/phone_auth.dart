import '../firebase_auth.dart';
import '../user_credential.dart';
import '../confirmation_result.dart';
import '../auth_credential.dart';

class PhoneAuth {
  final FirebaseAuth auth;

  PhoneAuth(this.auth);

  Future<ConfirmationResult> verifyPhoneNumber(String phoneNumber) async {
    final response = await auth.performRequest('sendVerificationCode', {
      'phoneNumber': phoneNumber,
      'recaptchaToken':
          'RECAPTCHA_TOKEN', // You might need to implement reCAPTCHA
    });

    return ConfirmationResult(
      verificationId: response['verificationId'],
      auth: auth,
    );
  }

  Future<UserCredential> signInWithCredential(
      PhoneAuthCredential credential) async {
    final response = await auth.performRequest('signInWithPhoneNumber', {
      'verificationId': credential.verificationId,
      'code': credential.smsCode,
    });

    final userCredential = UserCredential.fromJson(response);
    auth.updateCurrentUser(userCredential.user);
    return userCredential;
  }
}
