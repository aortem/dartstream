import 'dart:async';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth_credential.dart';

typedef PhoneVerificationCompleted = void Function(
    PhoneAuthCredential credential);
typedef PhoneVerificationFailed = void Function(FirebaseAuthException e);
typedef PhoneCodeSent = void Function(String verificationId, int? resendToken);
typedef PhoneCodeAutoRetrievalTimeout = void Function(String verificationId);

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

  Future<UserCredential> verifyPhoneNumberWithCode(
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

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    try {
      final verificationId = await sendVerificationCode(phoneNumber);
      codeSent(verificationId,
          null); // We don't use resendToken in this implementation

      // Simulate auto-retrieval timeout after 30 seconds
      Timer(Duration(seconds: 30),
          () => codeAutoRetrievalTimeout(verificationId));
    } catch (e) {
      verificationFailed(FirebaseAuthException(
        code: 'verification-failed',
        message: e.toString(),
      ));
    }
  }

  Future<String> _getRecaptchaToken() async {
    // In a real implementation, you would integrate with reCAPTCHA here
    // For this example, we'll just return a dummy token
    return 'dummy_recaptcha_token';
  }
}

class PhoneAuthProvider {
  static PhoneAuthCredential credential({
    required String verificationId,
    required String smsCode,
  }) {
    return PhoneAuthCredential(
        verificationId: verificationId, smsCode: smsCode);
  }
}
