import 'dart:async';

/// The core module of Dartstream.
/// Handles the foundational setup, configurations, and lifecycle of the framework.
class DSStandardCore {
  /// Centralized configuration data for the project.
  final Map<String, dynamic> projectConfig;

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

  /// Debug method to inspect the current configuration and services.
  /// Provides a quick overview of the core state.
  void debug() {
    print("Debugging Dartstream Standard Core:");
    projectConfig.forEach((key, value) {
      print("- $key: $value");
    });
  }
}
