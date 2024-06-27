abstract class AuthCredential {}

class EmailAuthCredential extends AuthCredential {
  final String email;
  final String password;

  EmailAuthCredential({required this.email, required this.password});
}

class PhoneAuthCredential extends AuthCredential {
  final String verificationId;
  final String smsCode;

  PhoneAuthCredential({required this.verificationId, required this.smsCode});
}
