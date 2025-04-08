import 'dart:async';
import '../../../standard_extensions/reactive_dataflow/lifecycle/base/ds_lifecycle_hooks.dart';

/// The core module of Dartstream.
/// Handles the foundational setup, configurations, and lifecycle of the framework.
class DSStandardCore {
  /// Centralized configuration data for the project.
  final Map<String, dynamic> projectConfig;

  // Extension registries for different levels
  final Map<String, dynamic> _coreExtensions = {};
  final Map<String, Map<String, List<dynamic>>> _extendedFeatures = {};
  final Map<String, dynamic> _thirdPartyEnhancements = {};

  /// Constructor to initialize the core with configuration data.
  /// [projectConfig] contains the initial setup for the project.
  DSStandardCore({required this.projectConfig});

  /// Initializes the core framework.
  /// This method ensures all necessary components are loaded and ready.
  Future<void> initialize() async {
    print("Initializing Dartstream Standard Core with configuration:");
    projectConfig.forEach((key, value) {
      print("- $key: $value");
    });

    // Additional initialization logic for core services or dependencies.
    await _initializeComponents();
  }

  /// Internal helper method to initialize specific components.
  /// Can include middleware, services, and extensions.
  Future<void> _initializeComponents() async {
    print("Loading core components...");
    // Core initialization logic can be expanded here.
  }

  /// Starts the framework.
  /// This is the entry point to start any processes or services the framework provides.
  void start() {
    print("Dartstream Standard Core started.");
    // Framework-specific startup logic can go here.
  }

  /// Stops the framework and performs cleanup.
  /// Ensures all resources are released properly.
  void stop() {
    print("Dartstream Standard Core stopped.");
    // Cleanup logic for stopping services or removing hooks.
  }

  /// Registers a service or feature into the core.
  /// This method provides extensibility for adding custom functionality.
  void registerService(String name, dynamic service) {
    print("Registering service: $name");
    projectConfig[name] = service;
  }

  /// Retrieves a registered service by name.
  /// Returns `null` if the service is not found.
  dynamic getService(String name) {
    return projectConfig[name];
  }

  /// Registers a core extension with the framework
  /// [extension] The core extension to register
  /// [baseFeature] The base feature this extension belongs to (e.g., "authentication")
  void registerCoreExtension({
    required dynamic extension,
    required String baseFeature,
  }) {
    print("Registering core extension for $baseFeature");
    _coreExtensions[baseFeature] = extension;

    // Initialize if extension supports lifecycle
    if (extension is LifecycleHook) {
      extension.onInitialize();
    }
  }

  /// Registers an extended feature for an existing core extension
  /// [coreExtensionName] The name of the core extension to extend
  /// [extension] The extended feature to register
  /// [featureName] The name of the extended feature
  bool registerExtendedFeature({
    required String coreExtensionName,
    required dynamic extension,
    required String featureName,
  }) {
    if (!_coreExtensions.containsKey(coreExtensionName)) {
      print(
        "Cannot register extended feature: Core extension $coreExtensionName not found",
      );
      return false;
    }

    print("Registering extended feature '$featureName' for $coreExtensionName");

    if (!_extendedFeatures.containsKey(coreExtensionName)) {
      _extendedFeatures[coreExtensionName] = {};
    }

    if (!_extendedFeatures[coreExtensionName]!.containsKey(featureName)) {
      _extendedFeatures[coreExtensionName]![featureName] = [];
    }

    _extendedFeatures[coreExtensionName]![featureName]!.add(extension);

    // Initialize if extension supports lifecycle
    if (extension is LifecycleHook) {
      extension.onInitialize();
    }

    return true;
  }

  /// Registers a third-party enhancement with the framework
  /// [extension] The third-party enhancement to register
  /// [name] The name of the enhancement
  void registerThirdPartyEnhancement(
    dynamic extension, {
    required String name,
  }) {
    print("Registering third-party enhancement: $name");
    _thirdPartyEnhancements[name] = extension;

    // Initialize if extension supports lifecycle
    if (extension is LifecycleHook) {
      extension.onInitialize();
    }
  }

  /// Gets a registered core extension
  T? getCoreExtension<T>(String name) {
    return _coreExtensions[name] as T?;
  }

  /// Gets extended features for a core extension
  Map<String, List<dynamic>>? getExtendedFeatures(String coreExtensionName) {
    return _extendedFeatures[coreExtensionName];
  }

  /// Gets a specific extended feature
  T? getExtendedFeature<T>(
    String coreExtensionName,
    String featureName, {
    int index = 0,
  }) {
    if (!_extendedFeatures.containsKey(coreExtensionName)) {
      return null;
    }
    if (!_extendedFeatures[coreExtensionName]!.containsKey(featureName)) {
      return null;
    }
    final features = _extendedFeatures[coreExtensionName]![featureName];
    if (index >= features!.length) {
      return null;
    }
    return features[index] as T?;
  }

  /// Gets a third-party enhancement
  T? getThirdPartyEnhancement<T>(String name) {
    return _thirdPartyEnhancements[name] as T?;
  }

  /// Lists all registered extensions
  Map<String, dynamic> listExtensions() {
    return {
      'core': _coreExtensions.keys.toList(),
      'extended': _extendedFeatures.map(
        (key, value) => MapEntry(key, value.keys.toList()),
      ),
      'thirdParty': _thirdPartyEnhancements.keys.toList(),
    };
  }

  /// Debug method to inspect the current configuration and services.
  /// Provides a quick overview of the core state.
  void debug() {
    print("Debugging Dartstream Standard Core:");
    print("Core Extensions: ${_coreExtensions.keys.join(', ')}");
    print("Extended Features: ${_extendedFeatures.keys.join(', ')}");
    print(
      "Third-Party Enhancements: ${_thirdPartyEnhancements.keys.join(', ')}",
    );
    projectConfig.forEach((key, value) {
      print("- $key: $value");
    });
  }
}
