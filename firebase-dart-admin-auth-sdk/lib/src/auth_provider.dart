import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

abstract class AuthProvider {
  String get providerId;
}

class EmailAuthProvider extends AuthProvider {
  static EmailAuthProvider get instance => EmailAuthProvider();

  @override
  String get providerId => 'password';

  EmailAuthCredential credential(
      {required String email, required String password}) {
    return EmailAuthCredential(email: email, password: password);
  }
}

class PhoneAuthProvider extends AuthProvider {
  static PhoneAuthProvider get instance => PhoneAuthProvider();

  @override
  String get providerId => 'phone';

  PhoneAuthCredential credential({
    required String verificationId,
    required String smsCode,
  }) {
    return PhoneAuthCredential(
        verificationId: verificationId, smsCode: smsCode);
  }
}

class GoogleAuthProvider extends AuthProvider {
  static GoogleAuthProvider get instance => GoogleAuthProvider();

  @override
  String get providerId => 'google.com';
}

class FacebookAuthProvider extends AuthProvider {
  static FacebookAuthProvider get instance => FacebookAuthProvider();

  @override
  String get providerId => 'facebook.com';
}
