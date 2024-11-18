// Additional extensions and shared logic for extensions.
// ds_standard_extensions.dart

import 'package:ds_standard_features/extensions/ds_feature_extension.dart';
import 'lifecycle/base/ds_lifecycle_hooks.dart';
import '../utilities/ds_di_container.dart';
import '../utilities/ds_services.dart';
import '../utilities/ds_logging.dart';
import '../utilities/ds_error_handling.dart';

/// Extension registration system for DartStream framework
class DartstreamExtensionSystem {
  final DartstreamDIContainer _container;
  final DartstreamServices _services;
  final DartstreamLogger _logger;

  // Storage for different extension levels
  final Map<String, DartstreamFeatureExtension> _coreExtensions = {};
  final Map<String, DartstreamFeatureExtension> _customFeatures = {};
  final Map<String, Map<String, DartstreamFeatureExtension>>
      _frameworkExtensions = {};

  DartstreamExtensionSystem({
    required DartstreamDIContainer container,
    required DartstreamServices services,
    required DartstreamLogger logger,
  })  : _container = container,
        _services = services,
        _logger = logger;

  /// Level 1: Register a core extension that affects core functionality
  Future<void> registerCoreExtension(
    DartstreamFeatureExtension extension, {
    bool initialize = true,
  }) async {
    try {
      _logger.log('Registering core extension: ${extension.name}');

      // Validate extension
      _validateExtension(extension);
      await _validateDependencies(extension);

      // Register core extension
      _coreExtensions[extension.name] = extension;

      // Configure and initialize
      await _configureAndInitializeExtension(extension, 'core');

      _logger.log('Successfully registered core extension: ${extension.name}');
    } catch (e) {
      throw DartstreamExtensionException(
        'Failed to register core extension ${extension.name}: $e',
      );
    }
  }

  /// Level 2: Register a custom feature that extends a core extension
  Future<void> registerCustomFeature(
    DartstreamFeatureExtension extension,
    String extendedFeature, {
    bool initialize = true,
  }) async {
    try {
      _logger.log('Registering custom feature: ${extension.name}');

      // Validate extension
      _validateExtension(extension);
      await _validateDependencies(extension);

      // Verify that the extended feature exists
      if (extendedFeature.isNotEmpty &&
          !_coreExtensions.containsKey(extendedFeature)) {
        throw DartstreamExtensionException(
          'Cannot find core feature "$extendedFeature" to extend',
        );
      }

      // Register custom feature
      _customFeatures[extension.name] = extension;

      // Configure and initialize
      await _configureAndInitializeExtension(
          extension, 'custom', extendedFeature);

      _logger.log('Successfully registered custom feature: ${extension.name}');
    } catch (e) {
      throw DartstreamExtensionException(
        'Failed to register custom feature ${extension.name}: $e',
      );
    }
  }

  /// Level 3: Register a framework extension that integrates with third-party packages
  Future<void> registerFrameworkExtension(
    DartstreamFeatureExtension extension,
    String framework,
    String coreExtension, {
    bool initialize = true,
  }) async {
    try {
      _logger.log(
          'Registering framework extension: ${extension.name} for $framework');

      // Validate extension
      _validateExtension(extension);
      await _validateDependencies(extension);

      // Verify core extension exists
      if (!_coreExtensions.containsKey(coreExtension)) {
        throw DartstreamExtensionException(
          'Cannot find core extension "$coreExtension" to extend',
        );
      }

      // Initialize framework map if needed
      _frameworkExtensions[framework] ??= {};

      // Register framework extension
      _frameworkExtensions[framework]![extension.name] = extension;

      // Configure and initialize
      await _configureAndInitializeExtension(
          extension, 'framework', coreExtension, framework);

      _logger.log(
          'Successfully registered framework extension: ${extension.name}');
    } catch (e) {
      throw DartstreamExtensionException(
        'Failed to register framework extension ${extension.name}: $e',
      );
    }
  }

  /// Shared logic to configure and initialize extensions based on their type and level
  Future<void> _configureAndInitializeExtension(
    DartstreamFeatureExtension extension,
    String level, [
    String? extendedFeature,
    String? framework,
  ]) async {
    extension.configure({
      'level': level,
      if (extendedFeature != null) 'extends': extendedFeature,
      if (framework != null) 'framework': framework,
    });
    extension.registerServices(_services);
    extension.injectDependencies(_container);

    if (extension.initialize) {
      await extension.initialize();
      extension.onStart();
    }
  }

  /// Validate an extension before registration
  void _validateExtension(DartstreamFeatureExtension extension) {
    if (extension.name.isEmpty) {
      throw DartstreamExtensionException('Extension name cannot be empty');
    }

    if (extension.version.isEmpty) {
      throw DartstreamExtensionException('Extension version cannot be empty');
    }

    if (extension.compatibleVersion.isEmpty) {
      throw DartstreamExtensionException(
          'Compatible version must be specified');
    }
  }

  /// Validate extension dependencies
  Future<void> _validateDependencies(
      DartstreamFeatureExtension extension) async {
    for (final dependency in extension.requiredExtensions) {
      if (!_coreExtensions.containsKey(dependency) &&
          !_customFeatures.containsKey(dependency)) {
        throw DartstreamExtensionException(
          'Required extension "$dependency" not found',
        );
      }
    }
  }

  /// Retrieve registered core extension
  DartstreamFeatureExtension? getCoreExtension(String name) =>
      _coreExtensions[name];

  /// Retrieve registered custom feature
  DartstreamFeatureExtension? getCustomFeature(String name) =>
      _customFeatures[name];

  /// Retrieve registered framework extension
  DartstreamFeatureExtension? getFrameworkExtension(
          String framework, String name) =>
      _frameworkExtensions[framework]?[name];

  /// Initialize all registered extensions in proper order
  Future<void> initializeAll() async {
    await _initializeExtensions(_coreExtensions.values);
    await _initializeExtensions(_customFeatures.values);
    await _initializeFrameworkExtensions();
  }

  /// Initialize extensions for a given level
  Future<void> _initializeExtensions(
      Iterable<DartstreamFeatureExtension> extensions) async {
    for (final extension in extensions) {
      await extension.initialize();
      extension.onStart();
    }
  }

  /// Initialize framework extensions in order
  Future<void> _initializeFrameworkExtensions() async {
    for (final frameworkMap in _frameworkExtensions.values) {
      for (final extension in frameworkMap.values) {
        await extension.initialize();
        extension.onStart();
      }
    }
  }

  /// Cleanup and dispose of all extensions
  Future<void> disposeAll() async {
    await _disposeExtensions(_frameworkExtensions.values);
    await _disposeExtensions(_customFeatures.values);
    await _disposeExtensions(_coreExtensions.values);
  }

  /// Dispose extensions for a given level
  Future<void> _disposeExtensions(
      Iterable<DartstreamFeatureExtension> extensions) async {
    for (final extension in extensions) {
      await extension.dispose();
    }
  }
}
