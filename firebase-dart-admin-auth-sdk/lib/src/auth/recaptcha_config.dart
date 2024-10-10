import 'dart:async';

abstract class RecaptchaConfigService {
  Future<void> initializeRecaptchaConfig(String siteKey);
  Future<String?> getRecaptchaToken();
}

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
