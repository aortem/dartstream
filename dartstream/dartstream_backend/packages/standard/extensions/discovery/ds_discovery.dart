import 'dart:convert';
import 'dart:io';
import 'package:yaml/yaml.dart';

class ExtensionManifest {
  final String name;
  final String version;
  final String description;
  final List<String> dependencies;
  final String entryPoint;

  ExtensionManifest({
    required this.name,
    required this.version,
    required this.description,
    required this.dependencies,
    required this.entryPoint,
  });

  factory ExtensionManifest.fromYaml(Map yaml) {
    // Validate manifest schema
    validateManifestSchema(yaml);

    return ExtensionManifest(
      name: yaml['name'],
      version: yaml['version'],
      description: yaml['description'] ?? '',
      dependencies: List<String>.from(yaml['dependencies'] ?? []),
      entryPoint: yaml['entry_point'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'version': version,
      'description': description,
      'dependencies': dependencies,
      'entry_point': entryPoint,
    };
  }

  /// Hook for onLoad
  void onLoad() {
    print('$name extension loaded.');
    // Add additional initialization logic here if needed.
  }

  /// Hook for onUnload
  void onUnload() {
    print('$name extension unloaded.');
    // Add cleanup logic here if needed.
  }

  /// Validate the schema of the manifest
  static void validateManifestSchema(Map manifestContent) {
    final requiredFields = ['name', 'version', 'entry_point'];
    for (var field in requiredFields) {
      if (!manifestContent.containsKey(field)) {
        throw FormatException(
            'Missing required field: $field in manifest.yaml');
      }
    }
  }
}

class ExtensionRegistry {
  final List<ExtensionManifest> _extensions = [];
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
  final String extensionsDirectory;
  final String? registryFile;
  bool useCache = true;

  ExtensionRegistry({required this.extensionsDirectory, this.registryFile});

  /// Discovers extensions from the directory structure.
  void discoverExtensions() {
    if (useCache && _extensions.isNotEmpty) {
      print('Using cached extensions.');
      return;
    }

    final rootDir = Directory(extensionsDirectory);
    if (!rootDir.existsSync()) {
      print('Extensions directory not found: $extensionsDirectory');
      return;
    }

    for (var extensionFolder in rootDir.listSync(recursive: false)) {
      if (extensionFolder is Directory) {
        final providersDir = Directory('${extensionFolder.path}/providers');
        if (providersDir.existsSync()) {
          for (var providerFolder in providersDir.listSync(recursive: false)) {
            if (providerFolder is Directory) {
              final manifestFile = File('${providerFolder.path}/manifest.yaml');
              if (manifestFile.existsSync()) {
                try {
                  final manifestContent =
                      loadYaml(manifestFile.readAsStringSync());
                  if (manifestContent is Map) {
                    final extension =
                        ExtensionManifest.fromYaml(manifestContent);
                    if (_validateDependencies(extension)) {
                      registerExtension(extension);
                    }
                  } else {
                    print(
                        'Invalid manifest format in ${manifestFile.path}. Expected a YAML map.');
                  }
                } catch (e) {
                  print('Error reading manifest in ${manifestFile.path}: $e');
                }
              } else {
                print('No manifest found in ${providerFolder.path}');
              }
            }
          }
        } else {
          print('No providers folder found in ${extensionFolder.path}');
        }
      }
    }

    if (registryFile != null) {
      saveRegistry();
    }
  }

  /// Validates extension dependencies against the framework components.
  bool _validateDependencies(ExtensionManifest extension) {
    for (var dependency in extension.dependencies) {
      final parts = dependency.split(' >='); // Parse "Name >=Version"
      if (parts.length < 2) {
        print('Invalid dependency format in ${extension.name}: $dependency');
        return false;
      }
      final name = parts[0];
      final requiredVersion = parts[1];

      if (!frameworkComponents.containsKey(name)) {
        print(
            'Error: Missing dependency "$name" for extension "${extension.name}".');
        return false;
      }

      if (_compareVersions(frameworkComponents[name]!, requiredVersion) < 0) {
        print(
            'Error: Incompatible dependency "$name". Requires >=$requiredVersion, found ${frameworkComponents[name]}.');
        return false;
      }
    }
    return true;
  }

  /// Compares two semantic version strings.
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

  /// Registers an extension into the registry.
  void registerExtension(ExtensionManifest extension) {
    print('Registering extension: ${extension.name} (${extension.version})');
    _extensions.add(extension);

    // Call lifecycle hook
    extension.onLoad();
    print('Loading entry point: ${extension.entryPoint}');
  }

  /// Saves the registered extensions into a central registry file.
  void saveRegistry() {
    if (registryFile == null) return;

    try {
      final file = File(registryFile!);
      final jsonContent =
          jsonEncode(_extensions.map((ext) => ext.toJson()).toList());
      file.writeAsStringSync(jsonContent);
      print('Registry saved to $registryFile');
    } catch (e) {
      print('Error saving registry file: $e');
    }
  }

  /// Returns a list of all registered extensions.
  List<ExtensionManifest> get extensions => _extensions;
}
