import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_dartweb_framework_base/core/ds_standard_web_core.dart';
import 'package:ds_standard_features/ds_standard_features.dart';
import 'package:flutter/material.dart';

/// Flutter web specific extension system.
/// Handles framework-specific extensions and their lifecycle.
class DSStandardWebExtensions {
  // Singleton instance
  static final DSStandardWebExtensions _instance =
      DSStandardWebExtensions._internal();
  factory DSStandardWebExtensions() => _instance;
  DSStandardWebExtensions._internal();

  // Extension registry
  final Map<String, WebExtension> _extensions = {};
  final Map<String, WebExtensionState> _extensionStates = {};

  /// Register a new web extension
  void registerExtension(String name, WebExtension extension) {
    if (_extensions.containsKey(name)) {
      throw Exception('Extension $name is already registered');
    }
    _extensions[name] = extension;
    _extensionStates[name] = WebExtensionState.registered;
  }

  /// Initialize a registered extension
  Future<void> initializeExtension(String name,
      {Map<String, dynamic>? config}) async {
    final extension = _extensions[name];
    if (extension == null) {
      throw Exception('Extension $name is not registered');
    }

    try {
      await extension.initialize(config ?? {});
      _extensionStates[name] = WebExtensionState.initialized;
    } catch (e) {
      _extensionStates[name] = WebExtensionState.error;
      print('Error initializing extension $name: $e');
      rethrow;
    }
  }

  /// Get the state of an extension
  WebExtensionState getExtensionState(String name) {
    return _extensionStates[name] ?? WebExtensionState.notRegistered;
  }

  /// Get an initialized extension by name
  T? getExtension<T extends WebExtension>(String name) {
    final extension = _extensions[name];
    if (extension == null) {
      return null;
    }
    if (_extensionStates[name] != WebExtensionState.initialized) {
      throw Exception('Extension $name is not initialized');
    }
    return extension as T;
  }

  /// Cleanup and dispose of extensions
  Future<void> dispose() async {
    for (var extension in _extensions.values) {
      try {
        await extension.dispose();
      } catch (e) {
        print('Error disposing extension: $e');
      }
    }
    _extensions.clear();
    _extensionStates.clear();
  }
}

/// Base class for web-specific extensions
abstract class WebExtension {
  /// Initialize the extension with config
  Future<void> initialize(Map<String, dynamic> config);

  /// Clean up resources
  Future<void> dispose();
}

/// Extension state enumeration
enum WebExtensionState { notRegistered, registered, initialized, error }

/// Widget extension base class
abstract class WidgetExtension extends WebExtension {
  Widget build(BuildContext context);
}

/// Service extension base class
abstract class ServiceExtension extends WebExtension {
  Future<void> executeService(Map<String, dynamic> params);
}

/// Example auth widget extension
class AuthWidgetExtension extends WidgetExtension {
  final DSAuthProvider _authProvider;

  AuthWidgetExtension(this._authProvider);

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    // Initialize auth widget with config
    await _authProvider.initialize(config);
  }

  @override
  Widget build(BuildContext context) {
    // Build auth widget UI
    return Container(); // Placeholder implementation
  }

  @override
  Future<void> dispose() async {
    // Cleanup auth widget resources
    if (_authProvider is Disposable) {
      await (_authProvider as Disposable).dispose();
    }
  }
}
