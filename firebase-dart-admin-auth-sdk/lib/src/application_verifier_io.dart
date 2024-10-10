import 'application_verifier.dart';

class RecaptchaVerifierIO implements RecaptchaVerifier {
  @override
  final String siteKey;

  RecaptchaVerifierIO(this.siteKey);

  @override
  String get type => 'recaptcha';

  @override
  Future<String> verify() async {
    throw UnimplementedError(
        'RecaptchaVerifier.verify() is not implemented for IO platforms.');
  }
}
