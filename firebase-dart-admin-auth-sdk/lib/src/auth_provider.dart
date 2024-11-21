/// An abstract base class representing an authentication provider,
/// used to identify the specific authentication method (e.g., email, phone, OAuth).
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

  static OAuthCredential credential({
    String? accessToken,
    String? idToken,
  }) {
    return OAuthCredential(
      providerId: 'google.com',
      accessToken: accessToken,
      idToken: idToken,
    );
  }
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

class OIDCAuthProvider implements AuthProvider {
  @override
  String get providerId => 'oidc.gcp';

  static OAuthCredential credential({
    String? accessToken,
    String? idToken,
  }) {
    return OAuthCredential(
      providerId: 'oidc.gcp',
      accessToken: accessToken,
      idToken: idToken,
    );
  }
}
