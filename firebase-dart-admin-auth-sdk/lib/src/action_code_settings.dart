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
      'url': url,
      'handleCodeInApp': handleCodeInApp,
      if (iOSBundleId != null) 'iOSBundleId': iOSBundleId,
      if (androidPackageName != null) 'androidPackageName': androidPackageName,
      if (androidInstallApp != null) 'androidInstallApp': androidInstallApp,
      if (androidMinimumVersion != null)
        'androidMinimumVersion': androidMinimumVersion,
      if (dynamicLinkDomain != null) 'dynamicLinkDomain': dynamicLinkDomain,
    };
  }
}
