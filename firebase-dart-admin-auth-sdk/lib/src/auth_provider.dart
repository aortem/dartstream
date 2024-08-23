import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

abstract class AuthProvider {
  String get providerId;
}

class FacebookAuthProvider implements AuthProvider {
  @override
  String get providerId => 'facebook.com';
}

class GoogleAuthProvider implements AuthProvider {
  @override
  String get providerId => 'google.com';
}

class TwitterAuthProvider implements AuthProvider {
  @override
  String get providerId => 'twitter.com';
}

class GithubAuthProvider implements AuthProvider {
  @override
  String get providerId => 'github.com';
}

class PhoneAuthProvider implements AuthProvider {
  @override
  String get providerId => 'phone';

  static PhoneAuthCredential credential({
    required String verificationId,
    required String smsCode,
  }) {
    return PhoneAuthCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}
