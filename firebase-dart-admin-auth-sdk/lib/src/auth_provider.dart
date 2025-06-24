import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

///auth provider
abstract class AuthProvider {
  ///provider id
  String get providerId;
}

///facebook

class FacebookAuthProvider implements AuthProvider {
  @override
  String get providerId => 'facebook.com';
}

///google

class GoogleAuthProvider implements AuthProvider {
  @override
  String get providerId => 'google.com';

  ///credentials provider
  static OAuthCredential credential({String? accessToken, String? idToken}) {
    return OAuthCredential(
      providerId: 'google.com',
      accessToken: accessToken,
      idToken: idToken,
    );
  }
}

///twitter

class TwitterAuthProvider implements AuthProvider {
  @override
  String get providerId => 'twitter.com';
}

///github

class GithubAuthProvider implements AuthProvider {
  @override
  String get providerId => 'github.com';
}

///phone auth

class PhoneAuthProvider implements AuthProvider {
  @override
  String get providerId => 'phone';

  ///credential

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

///OID Authentication

class OIDCAuthProvider implements AuthProvider {
  @override
  String get providerId => 'oidc.gcp';

  ///credential

  static OAuthCredential credential({String? accessToken, String? idToken}) {
    return OAuthCredential(
      providerId: 'oidc.gcp',
      accessToken: accessToken,
      idToken: idToken,
    );
  }
}
