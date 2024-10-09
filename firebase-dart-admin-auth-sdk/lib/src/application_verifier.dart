import 'dart:async';
import 'dart:js' as js;

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
    final completer = Completer<String>();

    js.context.callMethod('grecaptcha.ready', [
      () {
        js.context.callMethod('grecaptcha.execute', [
          siteKey,
          {'action': 'submit'}
        ]).then((token) {
          completer.complete(token as String);
        }).catchError((error) {
          completer.completeError(error);
        });
      }
    ]);

    return completer.future;
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
