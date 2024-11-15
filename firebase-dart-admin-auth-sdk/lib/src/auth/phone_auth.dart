import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';

class PhoneAuth {
  final FirebaseAuth auth;

  PhoneAuth(this.auth);

  Future<String> sendVerificationCode(String phoneNumber) async {
    final response = await auth.performRequest('sendVerificationCode', {
      'phoneNumber': phoneNumber,
      'recaptchaToken': await _getRecaptchaToken(),
    });

    return response.body['sessionInfo'];
  }

  Future<UserCredential> verifyPhoneNumber(
      String verificationId, String smsCode) async {
    final response = await auth.performRequest('verifyPhoneNumber', {
      'sessionInfo': verificationId,
      'code': smsCode,
    });

    if (response.body['phoneNumber'] == null) {
      throw FirebaseAuthException(
        code: 'invalid-verification-code',
        message: 'The SMS verification code is invalid.',
      );
    }

    final userCredential = UserCredential.fromJson(response.body);
    auth.updateCurrentUser(userCredential.user);
    return userCredential;
  }

  Future<String> _getRecaptchaToken() async {
    // In a real implementation, you would integrate with reCAPTCHA here
    // For this aortem, we'll just return a dummy token
    return 'dummy_recaptcha_token';
  }
}
