/// Represents settings used for configuring action codes (e.g., password reset,
/// email verification) in Firebase.
class ActionCodeSettings {
  /// The URL the user will be redirected to after completing the action.
  /// Must be a valid URL.
  final String url;

  /// Determines whether the action code link should be opened in the app or a
  /// browser. Defaults to `false` (opens in a browser).
  final bool handleCodeInApp;

  /// iOS-specific settings to be used with the action code.
  final String? iOSBundleId;

  /// Android-specific settings to be used with the action code.
  final String? androidPackageName;

  /// Android-specific settings to be used with the action code
  final bool? androidInstallApp;

  /// Android-specific settings to be used with the action code
  final String? androidMinimumVersion;

  /// Optional custom domain to use for the dynamic link, if applicable.
  final String? dynamicLinkDomain;

  /// Constructs an instance of [ActionCodeSettings].
  ///
  /// Parameters:
  /// - [url]: The URL the user will be redirected to.
  /// - [handleCodeInApp]: Whether to handle the code in-app. Defaults to `false`.
  /// - [iOS]: Optional iOS-specific settings.
  /// - [android]: Optional Android-specific settings.
  /// - [dynamicLinkDomain]: Optional custom dynamic link domain.
  ActionCodeSettings({
    required this.url,
    this.handleCodeInApp = false,
    this.iOSBundleId,
    this.androidPackageName,
    this.androidInstallApp,
    this.androidMinimumVersion,
    this.dynamicLinkDomain,
  });

  /// Converts this [ActionCodeSettings] instance into a `Map<String, dynamic>`
  /// suitable for Firebase action code requests.
  ///
  /// Returns a map containing only the non-null fields.
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

/// Represents iOS-specific settings for action code handling.
class IOSSettings {
  /// The bundle ID of the iOS app that will handle the action.
  final String bundleId;

  /// Constructs an instance of [IOSSettings].
  ///
  /// Parameters:
  /// - [bundleId]: The bundle ID of the iOS app.
  IOSSettings({required this.bundleId});
}

/// Represents Android-specific settings for action code handling.
class AndroidSettings {
  /// The package name of the Android app that will handle the action.
  final String packageName;

  /// Whether the app should be installed if not already installed on the device.
  final bool? installApp;

  /// The minimum version of the Android app required to handle the action.
  final String? minimumVersion;

  /// Constructs an instance of [AndroidSettings].
  ///
  /// Parameters:
  /// - [packageName]: The package name of the Android app.
  /// - [installApp]: Whether to install the app if it's not installed.
  /// - [minimumVersion]: The minimum version of the app required to handle the action.
  AndroidSettings({
    required this.packageName,
    this.installApp,
    this.minimumVersion,
  });
}
