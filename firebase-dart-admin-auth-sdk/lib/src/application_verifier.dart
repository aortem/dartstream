import 'dart:async';

///application verifier
abstract class ApplicationVerifier {
  ///type
  String get type;

  ///verify
  Future<String> verify();
}

///recaptcha
class RecaptchaVerifier implements ApplicationVerifier {
  ///site key
  final String siteKey;

  ///recaptcha

  RecaptchaVerifier(this.siteKey);

  @override
  String get type => 'recaptcha';

  @override
  Future<String> verify() async {
    throw UnimplementedError(
        'RecaptchaVerifier.verify() must be implemented by a platform-specific class.');
  }
}

///mock app verifyer

class MockApplicationVerifier implements ApplicationVerifier {
  @override
  String get type => 'recaptcha';

  @override
  Future<String> verify() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'mock_recaptcha_token';
  }
}
