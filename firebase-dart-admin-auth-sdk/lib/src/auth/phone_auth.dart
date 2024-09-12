import 'dart:async';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
import 'package:firebase_dart_admin_auth_sdk/src/application_verifier.dart';
import 'package:firebase_dart_admin_auth_sdk/src/confirmation_result.dart';

class PhoneAuth {
  final FirebaseAuth auth;

  PhoneAuth(this.auth);

  Future<ConfirmationResult> signInWithPhoneNumber(
    String phoneNumber,
    ApplicationVerifier appVerifier,
  ) async {
    if (!_isValidPhoneNumber(phoneNumber)) {
      throw FirebaseAuthException(
        code: 'invalid-phone-number',
        message: 'The provided phone number is not valid.',
      );
    }

    try {
      final recaptchaToken = await appVerifier.verify();

      final response = await auth.performRequest('sendVerificationCode', {
        'phoneNumber': phoneNumber,
        'recaptchaToken': recaptchaToken,
      });

      final sessionInfo = response.body['sessionInfo'];
      if (sessionInfo == null) {
        throw FirebaseAuthException(
          code: 'invalid-session-info',
          message: 'Invalid session information received from the server.',
        );
      }

      return ConfirmationResult(
        auth: auth,
        verificationId: sessionInfo,
        phoneNumber: phoneNumber,
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        rethrow;
      }
      throw FirebaseAuthException(
        code: 'phone-auth-error',
        message:
            'An error occurred during phone authentication: ${e.toString()}',
      );
    }
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    final phoneRegex = RegExp(r'^\+[1-9]\d{1,14}$');
    return phoneRegex.hasMatch(phoneNumber);
  }
}
