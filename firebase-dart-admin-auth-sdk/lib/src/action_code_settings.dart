class ActionCodeSettings {
  final String url;
  final bool handleCodeInApp;
  final IOSSettings? iOS;
  final AndroidSettings? android;
  final String? dynamicLinkDomain;

  ActionCodeSettings({
    required this.url,
    this.handleCodeInApp = false,
    this.iOS,
    this.android,
    this.dynamicLinkDomain,
  });

  Map<String, dynamic> toMap() {
    return {
      'continueUrl': url,
      'canHandleCodeInApp': handleCodeInApp,
      if (iOS != null) 'iOSBundleId': iOS!.bundleId,
      if (android != null) 'androidPackageName': android!.packageName,
      if (android?.installApp != null) 'androidInstallApp': android!.installApp,
      if (android?.minimumVersion != null)
        'androidMinimumVersion': android!.minimumVersion,
      if (dynamicLinkDomain != null) 'dynamicLinkDomain': dynamicLinkDomain,
    };
  }
}

class IOSSettings {
  final String bundleId;

  IOSSettings({required this.bundleId});
}

class AndroidSettings {
  final String packageName;
  final bool? installApp;
  final String? minimumVersion;

  AndroidSettings({
    required this.packageName,
    this.installApp,
    this.minimumVersion,
  });
}
