import 'dart:async';
import 'package:firebase_dart_admin_auth_sdk/src/firebase_auth.dart';
import 'package:firebase_dart_admin_auth_sdk/src/user_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/exceptions.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth_credential.dart';
import 'package:firebase_dart_admin_auth_sdk/src/confirmation_result.dart';
import 'package:firebase_dart_admin_auth_sdk/src/application_verifier.dart';

class PhoneAuth {
  final FirebaseAuth auth;

  PhoneAuth(this.auth);

  Future<ConfirmationResult> signInWithPhoneNumber(
    String phoneNumber,
    ApplicationVerifier appVerifier,
  ) async {
    final recaptchaToken = await appVerifier.verify();
    final response = await auth.performRequest('sendVerificationCode', {
      'phoneNumber': phoneNumber,
      'recaptchaToken': recaptchaToken,
    });

    final verificationId = response.body['sessionInfo'];
    return ConfirmationResult(auth: auth, verificationId: verificationId);
  }

  Future<UserCredential> confirmPhoneNumber(
    String verificationId,
    String smsCode,
  ) async {
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

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    try {
      final appVerifier = RecaptchaVerifier(
        container: 'recaptcha-container',
        size: RecaptchaVerifierSize.invisible,
        theme: RecaptchaVerifierTheme.light,
      );

      final confirmationResult =
          await signInWithPhoneNumber(phoneNumber, appVerifier);
      final verificationId = confirmationResult.verificationId;

      codeSent(verificationId, null);

      // Simulate auto-retrieval timeout after 30 seconds
      Timer(Duration(seconds: 30),
          () => codeAutoRetrievalTimeout(verificationId));

      // Simulate automatic SMS code retrieval after 5 seconds
      Timer(Duration(seconds: 5), () {
        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: '123456', // Simulated SMS code
        );
        verificationCompleted(credential);
      });
    } catch (e) {
      verificationFailed(FirebaseAuthException(
        code: 'verification-failed',
        message: e.toString(),
      ));
    }
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

typedef PhoneVerificationCompleted = void Function(
    PhoneAuthCredential credential);
typedef PhoneVerificationFailed = void Function(FirebaseAuthException e);
typedef PhoneCodeSent = void Function(String verificationId, int? resendToken);
typedef PhoneCodeAutoRetrievalTimeout = void Function(String verificationId);
