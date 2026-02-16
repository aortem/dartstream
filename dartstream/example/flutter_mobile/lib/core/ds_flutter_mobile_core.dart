/*core/:
The ds_flutter_mobile_core.dart file serves as the entry point for the Flutter Mobile framework integration. 
It initializes the framework-specific features, sets up any necessary configurations, 
and ensures that core functionality is correctly wired for Flutter Mobile. 
This file acts as a centralized place to manage the framework lifecycle and expose key features. */

import 'package:dartstream_backend/extensions/auth/base/lib/ds_auth_manager.dart';
import 'package:dartstream_backend/extensions/auth/ds_auth_export.dart';
import 'ds_flutter_mobile_auth_adapter.dart';

/// DSFlutterMobileCore is the entry point for Flutter Mobile integration
class DSFlutterMobileCore {
  static bool _isInitialized = false;

  /// Initializes the Flutter Mobile framework
  static Future<void> initialize({
    required String defaultAuthProvider,
    bool enableLogging = false,
  }) async {
    if (_isInitialized) {
      debugPrint('DSFlutterMobileCore is already initialized.');
      return;
    }

    // Register default auth providers
    DSAuthManager.registerProvider('firebase', DSFirebaseAuthProvider());
    DSAuthManager.registerProvider('azure', DSAzureADB2CAuthProvider());

    // Set up the default auth provider
    final authAdapter = DSFlutterMobileAuthAdapter(defaultAuthProvider);

    // Optionally enable logging
    if (enableLogging) {
      debugPrint(
          'DSFlutterMobileCore initialized with provider: $defaultAuthProvider');
    }

    _isInitialized = true;
  }
}
