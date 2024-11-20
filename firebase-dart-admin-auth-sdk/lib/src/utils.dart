import 'dart:math';

/// Validates if the provided email is in a proper format.
///
/// The email must match the format: [username]@[domain].[extension]
/// Example: "example@example.com"
///
/// Returns:
/// - `null` if the email is valid.
/// - An error message if the email format is invalid.
String? validateEmail(String email) {
  final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
  if (!emailRegExp.hasMatch(email)) {
    return 'Invalid email format';
  }
  return null;
}

/// Validates if the provided password meets the minimum length requirement.
///
/// The password must be at least 6 characters long.
///
/// Returns:
/// - `null` if the password is valid.
/// - An error message if the password is too short.
String? validatePassword(String password) {
  if (password.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  return null;
}

/// Settings used when sending an action code (such as email verification or password reset).
/// Contains details about how the action code should be handled on the client-side.
///
/// Example usage:
/// ```dart
/// ActionCodeSettings(
///   url: 'https://your-app.com/verify-email',
///   handleCodeInApp: true,
/// )
/// ```
class ActionCodeSettings {
  /// The URL to which the user should be redirected after completing the action.
  final String url;

  /// Whether the action code should be handled in the app or through the browser.
  final bool handleCodeInApp;

  /// Optional: iOS bundle ID to associate with the action code.
  final String? iOSBundleId;

  /// Optional: Android package name to associate with the action code.
  final String? androidPackageName;

  /// Optional: Whether the Android app should be installed if not already.
  final bool? androidInstallApp;

  /// Optional: Minimum version of the Android app required to handle the action code.
  final String? androidMinimumVersion;

  /// Optional: The domain for dynamic links to be used with the action code.
  final String? dynamicLinkDomain;

  /// Creates an instance of [ActionCodeSettings] with the required and optional properties.
  ActionCodeSettings({
    required this.url,
    this.handleCodeInApp = false,
    this.iOSBundleId,
    this.androidPackageName,
    this.androidInstallApp,
    this.androidMinimumVersion,
    this.dynamicLinkDomain,
  });

  /// Converts the [ActionCodeSettings] object to a map.
  /// This map can be used to send the settings in an API call.
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

/// Generates a unique identifier (UID) in the format of a UUIDv4.
///
/// UUID (Universally Unique Identifier) is a 128-bit value that is typically
/// represented as a 32-character string in the form `xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx`
/// where `x` is a random hexadecimal digit and `y` is a random digit from 8, 9, A, or B.
///
/// Returns:
/// - A randomly generated UUID (v4) string.
String generateUid() {
  final random = Random.secure();

  /// Generates a random hexadecimal string of the specified length.
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
