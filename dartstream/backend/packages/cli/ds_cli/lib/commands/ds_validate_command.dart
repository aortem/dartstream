import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:args/command_runner.dart';
import 'package:ds_discovery_provider/main.dart';
import 'package:yaml/yaml.dart';

class DSValidateCommand extends Command {
  @override
  final name = 'validate';

  @override
  final description =
      'Validates extensions, providers, and project configuration.';

  DSValidateCommand() {
    argParser
      ..addOption('project', abbr: 'p', help: 'Project to validate')
      ..addOption(
        'level',
        abbr: 'l',
        allowed: ['core', 'extended', 'third-party', 'all'],
        defaultsTo: 'all',
        help: 'Validate specific extension level',
      )
      ..addFlag(
        'strict',
        abbr: 's',
        help: 'Strict validation including code analysis',
        negatable: false,
      )
      ..addFlag(
        'providers',
        help: 'Validate provider compatibility',
        defaultsTo: true,
      );
  }

  @override
  Future<void> run() async {
    final projectName = argResults?['project'] as String?;
    final levelFilter = argResults?['level'] as String;
    final strictMode = argResults?['strict'] as bool;
    final validateProviders = argResults?['providers'] as bool;

    print('🔍 Starting validation...\n');

    // Validate project if specified
    if (projectName != null) {
      if (!await _validateProject(projectName)) {
        return;
      }
    }

    // Validate extensions
    await _validateExtensions(levelFilter, strictMode);

    // Validate providers
    if (validateProviders) {
      await _validateProviders();
    }

    print('\n✅ Validation complete!');
  }

  Future<bool> _validateProject(String projectName) async {
    print('📁 Validating project: $projectName');

    final projectDir = Directory(projectName);
    if (!projectDir.existsSync()) {
      print('❌ Project directory not found: $projectName');
      return false;
    }

    final errors = <String>[];

    // Check required files
    final requiredFiles = ['pubspec.yaml', 'config.yaml', 'lib/main.dart'];

    for (final file in requiredFiles) {
      final path = p.join(projectName, file);
      if (!File(path).existsSync()) {
        errors.add('Missing required file: $file');
      }
    }

    // Validate configuration
    final configPath = p.join(projectName, 'config.yaml');
    if (File(configPath).existsSync()) {
      try {
        final content = File(configPath).readAsStringSync();
        final config = loadYaml(content) as Map;

        // Validate vendor-provider compatibility
        final vendor = config['vendor'] as String?;
        final auth = config['auth'] as String?;

        if (vendor != null && auth != null) {
          if (!_isCompatible(vendor, auth)) {
            errors.add('Incompatible configuration: $vendor with $auth');
          }
        }
      } catch (e) {
        errors.add('Invalid config.yaml: $e');
      }
    }

    // Validate pubspec.yaml
    final pubspecPath = p.join(projectName, 'pubspec.yaml');
    if (File(pubspecPath).existsSync()) {
      try {
        final content = File(pubspecPath).readAsStringSync();
        final pubspec = loadYaml(content) as Map;

        // Check for required dependencies
        final deps = pubspec['dependencies'] as Map?;
        if (deps == null || !deps.containsKey('ds_standard_engine')) {
          errors.add('Missing required dependency: ds_standard_engine');
        }
      } catch (e) {
        errors.add('Invalid pubspec.yaml: $e');
      }
    }

    if (errors.isNotEmpty) {
      print('\n❌ Project validation failed:');
      for (final error in errors) {
        print('   • $error');
      }
      return false;
    }

    print('   ✓ Project structure valid');
    return true;
  }

  Future<void> _validateExtensions(String levelFilter, bool strictMode) async {
    print('\n📦 Validating extensions...');

    final extensionsDir = _findExtensionsDirectory();
    final registryFile = _findRegistryFile();

    if (!Directory(extensionsDir).existsSync()) {
      print('❌ Extensions directory not found');
      return;
    }

    try {
      final registry = ExtensionRegistry(
        extensionsDirectory: extensionsDir,
        registryFile: registryFile,
      );

      registry.discoverExtensions();

      // Filter by level
      var extensions = registry.extensions;
      if (levelFilter != 'all') {
        extensions = extensions.where((ext) {
          switch (levelFilter) {
            case 'core':
              return ext.level == ExtensionLevel.core;
            case 'extended':
              return ext.level == ExtensionLevel.extended;
            case 'third-party':
              return ext.level == ExtensionLevel.thirdParty;
            default:
              return true;
          }
        }).toList();
      }

      var hasErrors = false;
      for (final extension in extensions) {
        final result = _validateExtension(extension, registry, strictMode);

        if (result.errors.isNotEmpty) {
          print('\n   ✗ ${extension.name}:');
          for (final error in result.errors) {
            print('      • $error');
          }
          hasErrors = true;
        } else {
          print('   ✓ ${extension.name}');
        }

        if (result.warnings.isNotEmpty && strictMode) {
          for (final warning in result.warnings) {
            print('      ⚠️  $warning');
          }
        }
      }

      if (!hasErrors) {
        print('\n✅ All extensions valid');
      } else {
        print('\n⚠️  Some extensions have errors');
      }
    } catch (e) {
      print('❌ Error validating extensions: $e');
    }
  }

  ValidationResult _validateExtension(
    ExtensionManifest extension,
    ExtensionRegistry registry,
    bool strictMode,
  ) {
    final result = ValidationResult();

    // Basic validation
    if (extension.name.isEmpty) {
      result.addError('Missing name');
    }

    if (!_isValidVersion(extension.version)) {
      result.addError('Invalid version format: ${extension.version}');
    }

    // Provider-specific validation
    if (extension.name.contains('auth_provider')) {
      _validateAuthProvider(extension, result);
    } else if (extension.name.contains('database')) {
      _validateDatabaseProvider(extension, result);
    }

    // Dependency validation
    if (!registry.validateDependencies(extension)) {
      result.addError('Dependency validation failed');
    }

    // Entry point validation
    final entryPath = p.join(
      registry.extensionsDirectory,
      extension.entryPoint,
    );
    if (!File(entryPath).existsSync()) {
      result.addError('Entry point not found: ${extension.entryPoint}');
    } else if (strictMode) {
      _validateProviderCode(entryPath, extension, result);
    }

    return result;
  }

  void _validateAuthProvider(
    ExtensionManifest extension,
    ValidationResult result,
  ) {
    // Check for required auth provider structure
    final requiredFiles = [
      'ds_error_mapper.dart',
      'ds_session_manager.dart',
      'ds_token_manager.dart',
    ];

    final basePath = p.dirname(extension.entryPoint);
    for (final file in requiredFiles) {
      final filePath = p.join(basePath, 'src', file);
      if (!File(filePath).existsSync()) {
        result.addWarning('Missing standard auth file: src/$file');
      }
    }
  }

  void _validateDatabaseProvider(
    ExtensionManifest extension,
    ValidationResult result,
  ) {
    // Database providers should have specific methods
    if (!extension.dependencies.any((dep) => dep.contains('Core'))) {
      result.addWarning('Database providers should depend on Core');
    }
  }

  void _validateProviderCode(
    String filePath,
    ExtensionManifest extension,
    ValidationResult result,
  ) {
    try {
      final content = File(filePath).readAsStringSync();

      // Check for proper class structure
      if (extension.name.contains('auth_provider')) {
        if (!content.contains('extends DSAuthProvider') &&
            !content.contains('implements DSAuthProvider')) {
          result.addWarning(
            'Auth provider should extend or implement DSAuthProvider',
          );
        }
      }

      // Check for documentation
      if (!content.contains('///')) {
        result.addWarning('Missing documentation comments');
      }

      // Check for proper error handling
      if (!content.contains('try') && !content.contains('catch')) {
        result.addWarning('No error handling found');
      }
    } catch (e) {
      result.addError('Failed to analyze code: $e');
    }
  }

  Future<void> _validateProviders() async {
    print('\n🔌 Validating providers...');

    final providersPath = p.join(
      'packages',
      'standard',
      'standard_extensions',
      'auth',
      'providers',
    );

    if (!Directory(providersPath).existsSync()) {
      print('❌ Providers directory not found');
      return;
    }

    final providers = Directory(providersPath)
        .listSync()
        .whereType<Directory>()
        .map((dir) => p.basename(dir.path))
        .toList();

    print('   Found ${providers.length} auth providers:');

    for (final provider in providers) {
      final pubspecPath = p.join(providersPath, provider, 'pubspec.yaml');

      if (File(pubspecPath).existsSync()) {
        try {
          final content = File(pubspecPath).readAsStringSync();
          final pubspec = loadYaml(content) as Map;
          final version = pubspec['version'] as String?;

          if (version != null && version.contains('pre')) {
            print('   ⚠️  $provider: $version (pre-release)');
          } else {
            print('   ✓ $provider: $version');
          }
        } catch (e) {
          print('   ✗ $provider: Invalid pubspec');
        }
      } else {
        print('   ✗ $provider: Missing pubspec.yaml');
      }
    }
  }

  bool _isValidVersion(String version) {
    // Accept semantic versions and pre-release versions
    final pattern = RegExp(r'^\d+\.\d+\.\d+(-[\w\.]+)?(\+[\w\.]+)?$');
    return pattern.hasMatch(version);
  }

  bool _isCompatible(String vendor, String auth) {
    const compatibility = {
      'gcp': ['firebase', 'google_auth'],
      'aws': ['cognito', 'aws_auth'],
      'azure': ['entraid', 'azure_ad'],
      'local': ['firebase', 'auth0', 'magic', 'stytch', 'cognito', 'entraid'],
    };

    final compatible = compatibility[vendor] ?? [];
    return compatible.contains(auth) || vendor == 'local';
  }

  String _findExtensionsDirectory() {
    final paths = [
      p.join('packages', 'standard', 'standard_extensions'),
      p.join(
        '..',
        'dartstream_backend',
        'packages',
        'standard',
        'standard_extensions',
      ),
    ];

    for (final path in paths) {
      final fullPath = p.normalize(p.join(Directory.current.path, path));
      if (Directory(fullPath).existsSync()) {
        return fullPath;
      }
    }

    return p.normalize(
      p.join(
        Directory.current.path,
        'packages',
        'standard',
        'standard_extensions',
      ),
    );
  }

  String _findRegistryFile() {
    final paths = [
      'dartstream_registry.yaml',
      p.join('..', 'dartstream_registry.yaml'),
    ];

    for (final path in paths) {
      final fullPath = p.normalize(p.join(Directory.current.path, path));
      if (File(fullPath).existsSync()) {
        return fullPath;
      }
    }

    return p.normalize(
      p.join(Directory.current.path, 'dartstream_registry.yaml'),
    );
  }
}

class ValidationResult {
  final List<String> errors = [];
  final List<String> warnings = [];

  bool get isValid => errors.isEmpty;

  void addError(String error) => errors.add(error);
  void addWarning(String warning) => warnings.add(warning);
}
