/// Configuration for DartStream Auth Demo
class AppConfig {
  // Firebase project configuration
  static const String projectId = 'YOUR PROJECT ID'; //YOUR PROJECT ID
  static const String privateKeyPath =
      'config/service_account/service-account-key.json'; //YOUR SERVICE ACCOUNT KEY PATH
  static const String apiKey = 'YOUR API KEY'; //YOUR API KEY
  static const String storageBucket =
      'YOUR STORAGE BUCKET'; //YOUR STORAGE BUCKET
  static const String messagingSenderId =
      'YOUR MESSAGING ID'; //YOUR MESSAGING SENDER ID
  static const String appId = 'YOUR APP ID'; //YOUR APP ID

  // Debug and logging configuration
  static const bool enableDebugLogging = true;
  static const Duration sessionTimeout = Duration(hours: 1);
}
