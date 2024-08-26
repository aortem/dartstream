import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;

class RecaptchaConfigService {
  static const String recaptchaScriptUrl =
      'https://www.google.com/recaptcha/api.js?render=';
  String? _siteKey;
  bool _isInitialized = false;

  Future<void> initializeRecaptchaConfig(String siteKey) async {
    if (_isInitialized) return;

    try {
      _siteKey = siteKey;
      await _loadRecaptchaScript();
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize reCAPTCHA: $e');
    }
  }

  Future<void> _loadRecaptchaScript() async {
    if (_siteKey == null) throw Exception('Site key is not set');

    final scriptElement = html.ScriptElement()
      ..src = '$recaptchaScriptUrl$_siteKey'
      ..async = true
      ..defer = true;

    html.document.head?.children.add(scriptElement);

    await scriptElement.onLoad.first;
  }

  Future<String?> getRecaptchaToken() async {
    if (!_isInitialized) throw Exception('reCAPTCHA is not initialized');

    final completer = Completer<String?>();

    js.context.callMethod('grecaptcha.ready', [
      () {
        js.context.callMethod('grecaptcha.execute', [
          _siteKey,
          {'action': 'submit'}
        ]).then((token) {
          completer.complete(token as String?);
        }).catchError((error) {
          completer.completeError(error);
        });
      }
    ]);

    return completer.future;
  }
}
