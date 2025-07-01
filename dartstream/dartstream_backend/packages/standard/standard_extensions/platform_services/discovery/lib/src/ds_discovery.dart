import 'dart:convert';
import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:ds_lifecycle_base/main.dart';

/// Extension level enumeration to classify extension types
enum ExtensionLevel { core, extended, thirdParty }

/// Represents the structure of an extension manifest.
/// Includes lifecycle hooks for initialization and disposal.
class ExtensionManifest implements LifecycleHook {
  final String name;
  final String version;
  final String description;
  final List<String> dependencies;
  final String entryPoint;
  final ExtensionLevel level;
  final String?
  coreExtension; // For extended features, the core extension they enhance

  ExtensionManifest(
    this.name,
    this.version,
    this.description,
    this.dependencies,
    this.entryPoint,
    this.level,
    this.coreExtension,
  );

  /// Factory to create an `ExtensionManifest` object from YAML data.
  /// This helps standardize the metadata format for all extensions.
  factory ExtensionManifest.fromYaml(Map yaml) {
    // Parse extension level from string if provided
    ExtensionLevel level = ExtensionLevel.thirdParty; // Default

    if (yaml.containsKey('level')) {
      // Explicit level in manifest
      final levelStr = yaml['level'] as String;
      if (levelStr == 'core') {
        level = ExtensionLevel.core;
      } else if (levelStr == 'extended') {
        level = ExtensionLevel.extended;
      }
    } else {
      // Infer from core_extension presence (if exists, must be extended feature)
      if (yaml.containsKey('core_extension') &&
          yaml['core_extension'] != null) {
        level = ExtensionLevel.extended;
      } else {
        // Infer from name (auth providers are typically core)
        final name = yaml['name'] as String? ?? '';
        if (name.endsWith('Auth')) {
          level = ExtensionLevel.core;
        }
      }
    }

    return ExtensionManifest(
      yaml['name'],
      yaml['version'],
      yaml['description'] ?? '',
      List<String>.from(yaml['dependencies'] ?? []),
      yaml['entry_point'],
      level,
      yaml['core_extension'],
    );
  }

  /// Convert the manifest to JSON for saving or inspection purposes.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'version': version,
      'description': description,
      'dependencies': dependencies,
      'entry_point': entryPoint,
      'level': level.toString().split('.').last,
      'core_extension': coreExtension,
    };
  }

  /// Called when the extension is initialized.
  @override
  void onInitialize() {
    print('Initializing extension: $name');
  }

  /// Called when the extension is disposed.
  @override
  void onDispose() {
    print('Disposing extension: $name');
  }

  /// Called when the extension is registered
  @override
  void onRegister() {
    print('Registering extension: $name');
  }

  /// Called when configuration is updated
  @override
  void onConfigUpdate(Map<String, dynamic> config) {
    print('Config updated for extension: $name');
  }

  /// Simulate loading the entry point for the extension.
  void registerEntryPoint() {
    print('Entry point loaded for extension: $name');
  }
}

/// Registry to manage discovering and registering extensions.
/// Handles the discovery of extensions from directories, validates their
/// dependencies, and maintains a registry of all loaded extensions.
class ExtensionRegistry {
  // List of all registered extensions.
  final List<ExtensionManifest> _extensions = [];

  // List of currently active extensions.
  final List<String> _activeExtensions = [];

  // Framework components and their current versions.
  // Extensions must specify dependencies compatible with these components.
  final Map<String, String> frameworkComponents = {
    "Core": "0.0.1",
    "Auth": "0.0.1",
    "DataStreaming": "0.0.1",
    "Database": "0.0.1",
    "Events": "0.0.1",
    "FeatureFlags": "0.0.1",
    "Logging": "0.0.1",
    "Middleware": "0.0.1",
    "Notifications": "0.0.1",
    "Storage": "0.0.1",
  };

  // Path to the directory containing extensions.
  final String extensionsDirectory;

  // Optional path to save the registry metadata as a JSON file.
  final String? registryFile;

  ExtensionRegistry({required this.extensionsDirectory, this.registryFile});

  /// Discovers extensions in the specified directory structure.
  /// Reads each extension's `manifest.yaml` file, validates its dependencies,
  /// and registers it if valid.
  void discoverExtensions() {
    final rootDir = Directory(extensionsDirectory);
    if (!rootDir.existsSync()) {
      print('Extensions directory not found: $extensionsDirectory');
      return;
    }
    // Recursively search for `manifest.yaml` files
    for (var entity in rootDir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('manifest.yaml')) {
        try {
          // Safely parse YAML and handle null case
          final content = entity.readAsStringSync();
          if (content.trim().isEmpty) {
            print('Empty manifest file in ${entity.path}');
            continue;
          }

          final yamlDoc = loadYaml(content);
          if (yamlDoc == null) {
            print('Null YAML document in ${entity.path}');
            continue;
          }

          final manifestContent = yamlDoc as Map;
          final extension = ExtensionManifest.fromYaml(manifestContent);

          // Validate and register the extension.
          if (validateDependencies(extension)) {
            registerExtension(extension);
          }
        } catch (e) {
          print('Error reading manifest in ${entity.path}: $e');
        }
      }
    }

    // Save the registry to a file if a path is provided.
    if (registryFile != null) {
      saveRegistry();
    }
  }

  /// Discovers extensions by level
  /// This allows targeted loading of specific extension types
  void discoverExtensionsByLevel(ExtensionLevel level) {
    final rootDir = Directory(extensionsDirectory);
    if (!rootDir.existsSync()) {
      print('Extensions directory not found: $extensionsDirectory');
      return;
    }

    // Recursively search for `manifest.yaml` files
    for (var entity in rootDir.listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('manifest.yaml')) {
        try {
          // Safely parse YAML and handle null case
          final content = entity.readAsStringSync();
          if (content.trim().isEmpty) continue;

          final yamlDoc = loadYaml(content);
          if (yamlDoc == null) continue;

          final manifestContent = yamlDoc as Map;
          final extension = ExtensionManifest.fromYaml(manifestContent);

          // Only process extensions of the specified level
          if (extension.level == level && validateDependencies(extension)) {
            registerExtension(extension);
          }
        } catch (e) {
          print('Error reading manifest in ${entity.path}: $e');
        }
      }
    }
  }

  /// Registers an extension into the framework.
  /// Adds the extension to the registry, triggers its entry point,
  /// and invokes any lifecycle hooks.
  void registerExtension(ExtensionManifest extension) {
    print('Registering extension: ${extension.name} (${extension.version})');
    _extensions.add(extension);

    // Dynamically load the extension's entry point.
    extension.registerEntryPoint();

    // Trigger lifecycle hooks
    extension.onRegister();
    extension.onInitialize();
  }

  /// Unregisters an extension from the framework.
  /// Removes the extension from the registry and triggers its `onDispose` hook.
  void unregisterExtension(ExtensionManifest extension) {
    print('Unregistering extension: ${extension.name} (${extension.version})');
    _extensions.remove(extension);

    // Trigger lifecycle hooks
    extension.onDispose();
  }

  /// Enables an extension by name.
  void enableExtension(String extensionName) {
    if (!_extensions.any((ext) => ext.name == extensionName)) {
      print('Error: Extension "$extensionName" not found.');
      return;
    }
    if (!_activeExtensions.contains(extensionName)) {
      _activeExtensions.add(extensionName);
      print('Extension "$extensionName" enabled.');
    } else {
      print('Extension "$extensionName" is already enabled.');
    }
  }

  /// Disables an extension by name.
  void disableExtension(String extensionName) {
    if (_activeExtensions.remove(extensionName)) {
      print('Extension "$extensionName" disabled.');
    } else {
      print('Error: Extension "$extensionName" is not enabled.');
    }
  }

  /// Saves the list of active extensions to the registry file.
  void saveActiveExtensions() {
    if (registryFile == null) return;

    try {
      final file = File(registryFile!);
      final registryContent =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      registryContent['activeExtensions'] = _activeExtensions;
      file.writeAsStringSync(jsonEncode(registryContent));
      print('Active extensions saved to $registryFile');
    } catch (e) {
      print('Error saving active extensions: $e');
    }
  }

  /// Gets extensions of a specific level
  List<ExtensionManifest> getExtensionsByLevel(ExtensionLevel level) {
    return _extensions.where((ext) => ext.level == level).toList();
  }

  /// Gets core extensions
  List<ExtensionManifest> get coreExtensions =>
      getExtensionsByLevel(ExtensionLevel.core);

  /// Gets extended features
  List<ExtensionManifest> get extendedFeatures =>
      getExtensionsByLevel(ExtensionLevel.extended);

  /// Gets third-party enhancements
  List<ExtensionManifest> get thirdPartyEnhancements =>
      getExtensionsByLevel(ExtensionLevel.thirdParty);

  /// Gets extended features for a specific core extension
  List<ExtensionManifest> getExtendedFeaturesForCore(String coreExtensionName) {
    return _extensions
        .where(
          (ext) =>
              ext.level == ExtensionLevel.extended &&
              ext.coreExtension == coreExtensionName,
        )
        .toList();
  }

  /// Validates an extension's dependencies against the framework's components.
  /// Ensures that all required dependencies are present and their versions are compatible.
  bool validateDependencies(ExtensionManifest extension) {
    for (var dependency in extension.dependencies) {
      final parts = dependency.split(' >='); // Parse "Name >=Version".
      if (parts.length < 2) {
        print('Invalid dependency format in ${extension.name}: $dependency');
        return false;
      }
      final name = parts[0];
      final requiredVersion = parts[1];

      if (!frameworkComponents.containsKey(name)) {
        print(
          'Error: Missing dependency "$name" for extension "${extension.name}".',
        );
        return false;
      }

      if (_compareVersions(frameworkComponents[name]!, requiredVersion) < 0) {
        print(
          'Error: Incompatible dependency "$name". Requires >=$requiredVersion, found ${frameworkComponents[name]}.',
        );
        return false;
      }
    }
    return true;
  }

  /// Compares two semantic version numbers.
  /// Returns:
  /// -1 if `current` is less than `required`,
  ///  0 if they are equal,
  ///  1 if `current` is greater than `required`.
  int _compareVersions(String current, String required) {
    final currentParts = current.split('.').map(int.parse).toList();
    final requiredParts = required.split('.').map(int.parse).toList();
    for (int i = 0; i < requiredParts.length; i++) {
      if (i >= currentParts.length || currentParts[i] < requiredParts[i]) {
        return -1;
      }
      if (currentParts[i] > requiredParts[i]) return 1;
    }
    return 0;
  }

  /// Saves the registered extensions to a JSON file.
  /// This can be used to persist metadata about extensions for later use.
  void saveRegistry() {
    if (registryFile == null) return;

    try {
      final file = File(registryFile!);
      final Map<String, dynamic> registry = {
        'extensions': _extensions.map((ext) => ext.toJson()).toList(),
        'activeExtensions': _activeExtensions,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      final jsonContent = jsonEncode(registry);
      file.writeAsStringSync(jsonContent);
      print('Registry saved to $registryFile');
    } catch (e) {
      print('Error saving registry file: $e');
    }
  }

  /// Returns the list of all registered extensions.
  List<ExtensionManifest> get extensions => _extensions;

  /// Returns the list of active extensions.
  List<String> get activeExtensions => _activeExtensions;
}
