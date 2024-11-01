import 'dart:math';

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

String generateUid() {
  final random = Random.secure();

  String generateRandomHex(int length) {
    const hexDigits = '0123456789abcdef';
    return List.generate(length, (_) => hexDigits[random.nextInt(16)]).join();
  }

  // Set the version (UUIDv4)
  String uuid = '${generateRandomHex(8)}-'
      '${generateRandomHex(4)}-'
      '4${generateRandomHex(3)}-' // UUID version 4
      '${(random.nextInt(16) & 0x3 | 0x8).toRadixString(16)}${generateRandomHex(3)}-' // Variant
      '${generateRandomHex(12)}';

  return uuid;
}
