import 'dart:async';
import 'stub_js.dart' if (dart.library.js) 'dart:js' as js;
import 'application_verifier.dart';

///recaptcha
class RecaptchaVerifierWeb implements RecaptchaVerifier {
  @override
  final String siteKey;

  ///recaptcha
  RecaptchaVerifierWeb(this.siteKey);

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
