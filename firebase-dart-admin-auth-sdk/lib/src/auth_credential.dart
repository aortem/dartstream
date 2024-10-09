abstract class AuthCredential {
  final String providerId;

  AuthCredential(this.providerId);
}

class EmailAuthCredential extends AuthCredential {
  final String email;
  final String password;

  EmailAuthCredential({required this.email, required this.password})
      : super('password');
}

class PhoneAuthCredential extends AuthCredential {
  final String verificationId;
  final String smsCode;

  PhoneAuthCredential({required this.verificationId, required this.smsCode})
      : super('phone');
}

class OAuthCredential extends AuthCredential {
  final String? accessToken;
  final String? idToken;
  final String? signInMethod;

  OAuthCredential({
    required String providerId,
    this.accessToken,
    this.idToken,
    this.signInMethod,
  }) : super(providerId);
}
