import 'package:flutter/material.dart';

// Import framework components
import 'core/ds_standard_web_core.dart';
import 'api/ds_standard_web_api.dart';
import 'extensions/ds_standard_web_extensions.dart';
import 'overrides/ds_standard_web_overrides.dart';

/// Main entry point for Flutter web framework integration
class DSFlutterWebCore {
  // Singleton instance
  static final DSFlutterWebCore _instance = DSFlutterWebCore._internal();
  factory DSFlutterWebCore() => _instance;
  DSFlutterWebCore._internal();

  // Core components
  late final DSStandardWebCore _core;
  late final DSStandardWebApi _api;
  late final DSStandardWebExtensions _extensions;
  late final DSStandardWebOverrides _overrides;

  /// Initialize the Flutter web framework
  Future<void> initialize({
    required BuildContext context,
    required Map<String, dynamic> config,
  }) async {
    try {
      // Initialize core
      _core = DSStandardWebCore();
      await _core.initialize(config: config, context: context);

      // Initialize API
      _api = DSStandardWebApi();
      _api.initialize(context);

      // Initialize extensions
      _extensions = DSStandardWebExtensions();
      // Register default extensions if needed

      // Initialize overrides
      _overrides = DSStandardWebOverrides();
      _registerDefaultOverrides();

      print('Flutter web framework initialized successfully');
    } catch (e) {
      print('Error initializing Flutter web framework: $e');
      rethrow;
    }
  }

  /// Register default overrides
  void _registerDefaultOverrides() {
    _overrides.registerOverride<StorageProvider>(WebStorageOverride());
    // Register other default overrides
  }

  /// Access core components
  DSStandardWebCore get core => _core;
  DSStandardWebApi get api => _api;
  DSStandardWebExtensions get extensions => _extensions;
  DSStandardWebOverrides get overrides => _overrides;

  /// Clean up resources
  Future<void> dispose() async {
    await _core.dispose();
    await _extensions.dispose();
  }

  /// Check if framework is initialized
  bool get isInitialized => _core.isInitialized;
}

/// Helper methods for framework access
extension DSFlutterWebExtensions on BuildContext {
  DSFlutterWebCore get flutterWeb => DSFlutterWebCore();
}

/// Main application widget
class DartStreamWebApp extends StatelessWidget {
  final Widget child;
  final Map<String, dynamic> config;

  const DartStreamWebApp({
    super.key,
    required this.child,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeFramework(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error.toString());
          }
          return child;
        }
        return _buildLoadingWidget();
      },
    );
  }

  Future<void> _initializeFramework(BuildContext context) async {
    await DSFlutterWebCore().initialize(
      context: context,
      config: config,
    );
  }

  Widget _buildErrorWidget(String error) {
    return Material(
      child: Center(
        child: Text('Error initializing framework: $error'),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Material(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
