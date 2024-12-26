/// Configuration for DartStream Auth Demo
class AppConfig {
  // Firebase project configuration
  static const String projectId = 'YOUR_FIREBASE_PROJECT_ID';
  static const String privateKeyPath = 'YOUR_PRIVATE_KEY_PATH';

  // Enable debug logging
  static const bool enableDebugLogging = true;

  // Auth configuration
  static const Duration sessionTimeout = Duration(hours: 1);
}
