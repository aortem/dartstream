import 'package:firebase_dart_admin_auth_sdk/src/application_verifier_io.dart';
import 'package:firebase_dart_admin_auth_sdk/src/application_verifier_web.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/recaptcha_config_io.dart';
import 'package:firebase_dart_admin_auth_sdk/src/auth/recaptcha_config_web.dart';
import 'package:firebase_dart_admin_auth_sdk/src/popup_redirect_resolver_io.dart';
import 'package:firebase_dart_admin_auth_sdk/src/popup_redirect_resolver_web.dart';

import 'application_verifier.dart';
import 'popup_redirect_resolver.dart';
import 'auth/recaptcha_config.dart';

// For web
export 'application_verifier_web.dart'
    if (dart.library.io) 'application_verifier_io.dart';
export 'popup_redirect_resolver_web.dart'
    if (dart.library.io) 'popup_redirect_resolver_io.dart';
export 'auth/recaptcha_config_web.dart'
    if (dart.library.io) 'auth/recaptcha_config_io.dart';

///create recaptcha config

RecaptchaVerifier createRecaptchaVerifier(String siteKey) {
  if (isWeb) {
    return RecaptchaVerifierWeb(siteKey);
  } else {
    return RecaptchaVerifierIO(siteKey);
  }
}

///popup resolver

PopupRedirectResolver createPopupRedirectResolver() {
  if (isWeb) {
    return PopupRedirectResolverWeb();
  } else {
    return PopupRedirectResolverIO();
  }
}

///application verifier

RecaptchaConfigService createRecaptchaConfigService() {
  if (isWeb) {
    return RecaptchaConfigServiceWeb();
  } else {
    return RecaptchaConfigServiceIO();
  }
}

///is web

bool get isWeb {
  try {
    return identical(0, 0.0);
  } catch (_) {
    return false;
  }
}
