import 'recaptcha_config.dart';

///recaptcha
class RecaptchaConfigServiceIO implements RecaptchaConfigService {
  @override
  Future<void> initializeRecaptchaConfig(String siteKey) async {
    throw UnimplementedError(
        'RecaptchaConfigService.initializeRecaptchaConfig() is not implemented for IO platforms.');
  }

  @override
  Future<String?> getRecaptchaToken() async {
    throw UnimplementedError(
        'RecaptchaConfigService.getRecaptchaToken() is not implemented for IO platforms.');
  }
}
