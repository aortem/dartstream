String? validateEmail(String email) {
  final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  if (!emailRegExp.hasMatch(email)) {
    return 'Invalid email format';
  }
  return null;
}

String? validatePassword(String password) {
  if (password.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  return null;
}

class ActionCodeSettings {
  final String url;
  final bool handleCodeInApp;
  final String? iOSBundleId;
  final String? androidPackageName;
  final bool? androidInstallApp;
  final String? androidMinimumVersion;
  final String? dynamicLinkDomain;

  ActionCodeSettings({
    required this.url,
    this.handleCodeInApp = false,
    this.iOSBundleId,
    this.androidPackageName,
    this.androidInstallApp,
    this.androidMinimumVersion,
    this.dynamicLinkDomain,
  });

  Map<String, dynamic> toMap() {
    return {
      'continueUrl': url,
      'canHandleCodeInApp': handleCodeInApp,
      if (iOSBundleId != null) 'iOSBundleId': iOSBundleId,
      if (androidPackageName != null) 'androidPackageName': androidPackageName,
      if (androidInstallApp != null) 'androidInstallApp': androidInstallApp,
      if (androidMinimumVersion != null)
        'androidMinimumVersion': androidMinimumVersion,
      if (dynamicLinkDomain != null) 'dynamicLinkDomain': dynamicLinkDomain,
    };
  }
}
