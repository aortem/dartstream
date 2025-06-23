import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:args/command_runner.dart';
import '../../dartstream_backend/packages/standard/standard_extensions/platform_services/discovery/ds_discovery.dart';

/// CLI Command for validating extensions.
class DSValidateCommand extends Command {
  @override
  final name = 'validate';

  @override
  final description =
      'Validates all discovered extensions for manifest correctness and dependency compatibility.';

  /// Constructor to initialize the validate command.
  DSValidateCommand() {
    argParser.addOption(
      'level',
      abbr: 'l',
      help: 'Validate extensions of a specific level',
      allowed: ['core', 'extended', 'third-party', 'all'],
      defaultsTo: 'all',
    );

    argParser.addFlag(
      'strict',
      abbr: 's',
      help: 'Perform stricter validation including code standards',
      negatable: false,
    );
  }

  /// Executes the validation logic.
  @override
  Future<void> run() async {
    final args = argResults?.arguments ?? [];
    // Resolve extensions directory relative to this script
    final scriptDir = p.dirname(Platform.script.toFilePath());
    final extensionsDirectory =
        args.isNotEmpty
            ? args[0]
            : p.normalize(
              p.join(
                scriptDir,
                '../dartstream_backend/packages/standard/extensions',
              ),
            );
    final registryFile =
        args.length > 1
            ? args[1]
            : p.normalize(p.join(scriptDir, '../dartstream_registry.json'));

    final levelFilter = argResults?['level'] as String;
    final strictMode = argResults?['strict'] as bool;

    print('Validating extensions...');
    print('- Extensions directory: $extensionsDirectory');
    print('- Registry file: $registryFile');
    if (levelFilter != 'all') {
      print('- Validating only $levelFilter extensions');
    }
    if (strictMode) {
      print('- Using strict validation mode');
    }
    print('');

    try {
      final registry = ExtensionRegistry(
        extensionsDirectory: extensionsDirectory,
        registryFile: registryFile,
      );

      registry.discoverExtensions();

      if (registry.extensions.isEmpty) {
        print('No extensions discovered for validation.');
        return;
      }

      // Filter extensions by level if requested
      List<ExtensionManifest> extensionsToValidate = [];
      switch (levelFilter) {
        case 'core':
          extensionsToValidate = registry.coreExtensions;
          break;
        case 'extended':
          extensionsToValidate = registry.extendedFeatures;
          break;
        case 'third-party':
          extensionsToValidate = registry.thirdPartyEnhancements;
          break;
        default:
          extensionsToValidate = registry.extensions;
      }

      if (extensionsToValidate.isEmpty) {
        print('No extensions found matching the level filter: $levelFilter');
        return;
      }

      bool allValid = true;
      final validationResults = <String, _ValidationResult>{};

      for (final extension in extensionsToValidate) {
        print(
          'Validating extension: ${extension.name} (${extension.version}) - ${_getLevelString(extension.level)}',
        );

        final result = _ValidationResult();

        // Validate manifest fields
        if (!_validateManifestFields(extension, result)) {
          allValid = false;
        }

        // Validate dependencies
        if (!registry.validateDependencies(extension)) {
          allValid = false;
          result.addError('Dependency issues detected.');
        }

        // Validate level-specific requirements
        if (!_validateLevelSpecificRequirements(extension, registry, result)) {
          allValid = false;
        }

        // Additional strict validations if enabled
        if (strictMode) {
          if (!_performStrictValidation(
            extension,
            extensionsDirectory,
            result,
          )) {
            allValid = false;
          }
        }

        // Store validation result
        validationResults[extension.name] = result;

        // Print result status
        if (result.isValid) {
          print('✓ Validation successful for ${extension.name}.\n');
        } else {
          print('✗ Validation failed for ${extension.name}:');
          for (final error in result.errors) {
            print('  - $error');
          }
          for (final warning in result.warnings) {
            print('  - Warning: $warning');
          }
          print('');
        }
      }

      if (allValid) {
        print('All extensions validated successfully.');
      } else {
        print('Some extensions failed validation. Check the errors above.');
      }
    } catch (e) {
      print('Error during validation: $e');
    }
  }

  /// Validates required fields in the manifest.
  bool _validateManifestFields(
    ExtensionManifest extension,
    _ValidationResult result,
  ) {
    bool isValid = true;

    if (extension.name.isEmpty) {
      result.addError('Missing required field: name');
      isValid = false;
    }

    if (extension.version.isEmpty) {
      result.addError('Missing required field: version');
      isValid = false;
    } else if (!_isValidVersion(extension.version)) {
      result.addError(
        'Invalid version format: ${extension.version}. Expected semver (e.g., 1.0.0)',
      );
      isValid = false;
    }

    if (extension.entryPoint.isEmpty) {
      result.addError('Missing required field: entry_point');
      isValid = false;
    }

    if (extension.level == ExtensionLevel.extended &&
        extension.coreExtension == null) {
      result.addError('Extended features must specify a core_extension');
      isValid = false;
    }

    return isValid;
  }

  /// Validates level-specific requirements
  bool _validateLevelSpecificRequirements(
    ExtensionManifest extension,
    ExtensionRegistry registry,
    _ValidationResult result,
  ) {
    bool isValid = true;

    switch (extension.level) {
      case ExtensionLevel.core:
        // Core extensions should have at least Auth dependency
        if (!extension.dependencies.any((dep) => dep.startsWith('Auth'))) {
          result.addWarning('Core extensions typically depend on Auth');
        }
        break;

      case ExtensionLevel.extended:
        // Extended features must have a valid core extension reference
        final coreExt = extension.coreExtension;
        if (coreExt != null) {
          final coreExists = registry.extensions.any(
            (ext) => ext.name == coreExt && ext.level == ExtensionLevel.core,
          );

          if (!coreExists) {
            result.addError('Referenced core extension "$coreExt" not found');
            isValid = false;
          }
        }
        break;

      case ExtensionLevel.thirdParty:
        // Third-party enhancements should not modify core functionality directly
        // This would need code analysis, but here we just check naming conventions
        if (extension.name.startsWith('Core')) {
          result.addWarning(
            'Third-party enhancements should not use "Core" prefix',
          );
        }
        break;
    }

    return isValid;
  }

  /// Performs stricter validation including code patterns
  bool _performStrictValidation(
    ExtensionManifest extension,
    String extensionsDirectory,
    _ValidationResult result,
  ) {
    bool isValid = true;

    // Check entry point file exists
    final entryPointFile = File(
      p.join(extensionsDirectory, extension.entryPoint),
    );
    if (!entryPointFile.existsSync()) {
      result.addError('Entry point file not found: ${extension.entryPoint}');
      isValid = false;
    } else {
      // Check file content (basic checks)
      final content = entryPointFile.readAsStringSync();

      // Check for appropriate class naming based on extension level
      switch (extension.level) {
        case ExtensionLevel.core:
          if (!content.contains('CoreExtension') &&
              !content.contains('CoreLifecycle')) {
            result.addWarning(
              'Core extensions should use CoreExtension or implement CoreExtensionLifecycle',
            );
          }
          break;

        case ExtensionLevel.extended:
          if (!content.contains('ExtendedFeature') &&
              !content.contains('ExtendedFeatureLifecycle')) {
            result.addWarning(
              'Extended features should use ExtendedFeature or implement ExtendedFeatureLifecycle',
            );
          }
          break;

        case ExtensionLevel.thirdParty:
          if (!content.contains('ThirdParty') &&
              !content.contains('ThirdPartyLifecycle')) {
            result.addWarning(
              'Third-party enhancements should use ThirdParty or implement ThirdPartyLifecycle',
            );
          }
          break;
      }

      // Check for class documentation
      if (!content.contains('///')) {
        result.addWarning('Missing documentation comments');
      }
    }

    return isValid;
  }

  bool _isValidVersion(String version) {
    // Simple semver check (major.minor.patch)
    final pattern = RegExp(r'^\d+\.\d+\.\d+$');
    return pattern.hasMatch(version);
  }

  String _getLevelString(ExtensionLevel level) {
    switch (level) {
      case ExtensionLevel.core:
        return 'Core Extension';
      case ExtensionLevel.extended:
        return 'Extended Feature';
      case ExtensionLevel.thirdParty:
        return 'Third-Party Enhancement';
    }
  }
}

/// Stores validation result information
class _ValidationResult {
  final List<String> errors = [];
  final List<String> warnings = [];

  bool get isValid => errors.isEmpty;

  void addError(String error) {
    errors.add(error);
  }

  void addWarning(String warning) {
    warnings.add(warning);
  }
}
