import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

abstract class AuthProvider {}

class EmailAuthProvider extends AuthProvider {
  static EmailAuthProvider get instance => EmailAuthProvider();

  EmailAuthCredential credential(
      {required String email, required String password}) {
    return EmailAuthCredential(email: email, password: password);
  }
}

class PhoneAuthProvider extends AuthProvider {
  static PhoneAuthProvider get instance => PhoneAuthProvider();
}

class GoogleAuthProvider extends AuthProvider {
  static GoogleAuthProvider get instance => GoogleAuthProvider();
}

class FacebookAuthProvider extends AuthProvider {
  static FacebookAuthProvider get instance => FacebookAuthProvider();
}
