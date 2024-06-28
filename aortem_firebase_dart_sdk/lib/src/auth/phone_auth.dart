import '../firebase_auth.dart';
import '../user_credential.dart';
import '../exceptions.dart';

class PhoneAuth {
  final FirebaseAuth auth;

  PhoneAuth(this.auth);

  Future<String> sendVerificationCode(String phoneNumber) async {
    final response = await auth.performRequest('sendVerificationCode', {
      'phoneNumber': phoneNumber,
      'recaptchaToken': await _getRecaptchaToken(),
    });

    return response['sessionInfo'];
  }

  Future<UserCredential> verifyPhoneNumber(
      String verificationId, String smsCode) async {
    final response = await auth.performRequest('verifyPhoneNumber', {
      'sessionInfo': verificationId,
      'code': smsCode,
    });

    if (response['phoneNumber'] == null) {
      throw FirebaseAuthException(
        code: 'invalid-verification-code',
        message: 'The SMS verification code is invalid.',
      );
    }

    final userCredential = UserCredential.fromJson(response);
    auth.updateCurrentUser(userCredential.user);
    return userCredential;
  }

  Future<String> _getRecaptchaToken() async {
    // In a real implementation, you would integrate with reCAPTCHA here
    // For this example, we'll just return a dummy token
    return 'dummy_recaptcha_token';
  }
}
