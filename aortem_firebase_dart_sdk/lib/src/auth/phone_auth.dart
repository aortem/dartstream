import 'auth_base.dart';
import '../user_credential.dart';
import '../confirmation_result.dart';
import '../auth_credential.dart';

class PhoneAuth extends AuthBase {
  PhoneAuth(super.auth);

  Future<ConfirmationResult> verifyPhoneNumber(String phoneNumber) async {
    final response = await _performRequest('sendVerificationCode', {
      'phoneNumber': phoneNumber,
      'recaptchaToken': 'RECAPTCHA_TOKEN', // You'd need to implement reCAPTCHA
    });

    return ConfirmationResult(
        verificationId: response['sessionInfo'], auth: _auth);
  }

  Future<UserCredential> signInWithCredential(
      PhoneAuthCredential credential) async {
    final response = await _performRequest('signInWithPhoneNumber', {
      'sessionInfo': credential.verificationId,
      'code': credential.smsCode,
    });

    final userCredential = UserCredential.fromJson(response);
    _auth._updateCurrentUser(userCredential.user);
    return userCredential;
  }
}
