abstract class AuthCredential {
  final String providerId;

  AuthCredential(this.providerId);
}

class PhoneAuthCredential extends AuthCredential {
  final String verificationId;
  final String smsCode;

  PhoneAuthCredential({required this.verificationId, required this.smsCode})
      : super('phone');
}
