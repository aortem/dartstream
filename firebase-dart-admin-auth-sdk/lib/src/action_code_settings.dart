class ActionCodeSettings {
  final String? url;
  final bool? handleCodeInApp;
  final String? iOSBundleId;
  final String? androidPackageName;
  final bool? androidInstallApp;
  final String? androidMinimumVersion;
  final String? dynamicLinkDomain;

  ActionCodeSettings({
    this.url,
    this.handleCodeInApp,
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
      'iOS': {'bundleId': iOSBundleId},
      'android': {
        'packageName': androidPackageName,
        'installApp': androidInstallApp,
        'minimumVersion': androidMinimumVersion,
      },
      'dynamicLinkDomain': dynamicLinkDomain,
    }..removeWhere((key, value) => value == null);
  }
}
