import 'dart:async';

abstract class ApplicationVerifier {
  String get type;
  Future<String> verify();
}

class RecaptchaVerifier implements ApplicationVerifier {
  final String siteKey;

  RecaptchaVerifier(this.siteKey);

  @override
  String get type => 'recaptcha';

  @override
  Future<String> verify() async {
    throw UnimplementedError(
        'RecaptchaVerifier.verify() must be implemented by a platform-specific class.');
  }
}

class MockApplicationVerifier implements ApplicationVerifier {
  @override
  String get type => 'recaptcha';

  @override
  Future<String> verify() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'mock_recaptcha_token';
  }
}
