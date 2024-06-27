String? validateEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(email)) {
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

String? validatePhoneNumber(String phoneNumber) {
  final phoneRegex = RegExp(r'^\+?[1-9]\d{1,14}$');
  if (!phoneRegex.hasMatch(phoneNumber)) {
    return 'Invalid phone number format';
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

  ActionCodeSettings({
    required this.url,
    required this.handleCodeInApp,
    this.iOSBundleId,
    this.androidPackageName,
    this.androidInstallApp,
    this.androidMinimumVersion,
  });

  Map<String, dynamic> toMap() {
    return {
      'continueUrl': url,
      'handleCodeInApp': handleCodeInApp,
      if (iOSBundleId != null) 'iOSBundleId': iOSBundleId,
      if (androidPackageName != null) 'androidPackageName': androidPackageName,
      if (androidInstallApp != null) 'androidInstallApp': androidInstallApp,
      if (androidMinimumVersion != null)
        'androidMinimumVersion': androidMinimumVersion,
    };
  }
}
