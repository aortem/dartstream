abstract class AuthProvider {}

class EmailAuthProvider extends AuthProvider {
  static EmailAuthProvider get instance => EmailAuthProvider();
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
