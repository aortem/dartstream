import 'dart:async';

///recaptcha config
abstract class RecaptchaConfigService {
  ///recaptcha string
  Future<void> initializeRecaptchaConfig(String siteKey);

  ///recaptcha token
  Future<String?> getRecaptchaToken();
}

///recaptcha config
class RecaptchaConfigServiceStub implements RecaptchaConfigService {
  @override
  Future<void> initializeRecaptchaConfig(String siteKey) async {
    throw UnimplementedError(
        'RecaptchaConfigService.initializeRecaptchaConfig() must be implemented by a platform-specific class.');
  }

  @override
  Future<String?> getRecaptchaToken() async {
    throw UnimplementedError(
        'RecaptchaConfigService.getRecaptchaToken() must be implemented by a platform-specific class.');
  }
}
