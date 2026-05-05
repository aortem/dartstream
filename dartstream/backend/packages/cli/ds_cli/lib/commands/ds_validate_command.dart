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
      )
      ..addFlag(
        'prefix-check',
        help: 'Validate manifest naming and compatibility fields',
        negatable: false,
      );
  }

  /// Walks up the directory tree to find the dartstream backend root.
  /// The root is identified as the directory that contains a 'packages/' folder.
  /// This is the same approach used by DSInitCommand._findDartstreamRoot().
  String _findDartstreamRoot() {
    var currentDir = Directory.current;
    while (!Directory(p.join(currentDir.path, 'packages')).existsSync()) {
      final parent = currentDir.parent;
      if (parent.path == currentDir.path) {
        // Reached filesystem root, default to current directory
        return Directory.current.path;
      }
      currentDir = parent;
    }
    return currentDir.path;
  }

  @override
  Future<void> run() async {
    final projectName = argResults?['project'] as String?;
    final levelFilter = argResults?['level'] as String;
    final strictMode = argResults?['strict'] as bool;
    final validateProviders = argResults?['providers'] as bool;
    final prefixCheck = argResults?['prefix-check'] as bool;

    print('Starting validation...');

    if (projectName != null) {
      if (!await _validateProject(projectName)) {
        return;
      }
    }

    await _validateExtensions(levelFilter, strictMode);

    if (validateProviders) {
      await _validateProviders();
    }

    if (prefixCheck) {
      await _validateManifestAndPrefixStandards();
    }

    print('\nValidation complete.');
  }

  Future<bool> _validateProject(String projectName) async {
    print('ðŸ“ Validating project: $projectName');

    final dartstreamRoot = _findDartstreamRoot();
    final projectPath = _resolveProjectPath(projectName, dartstreamRoot);
    final projectDir = Directory(projectPath);
    if (!projectDir.existsSync()) {
      print('Project directory not found: $projectName');
      return false;
    }

    final errors = <String>[];
    const requiredFiles = ['pubspec.yaml', 'config.yaml', 'lib/main.dart'];

    for (final file in requiredFiles) {
      final path = p.join(projectPath, file);
      if (!File(path).existsSync()) {
        errors.add('Missing required file: $file');
      }
    }

    // Validate configuration
    final configPath = p.join(projectPath, 'config.yaml');
    if (File(configPath).existsSync()) {
      try {
        final content = File(configPath).readAsStringSync();
        final config = loadYaml(content) as Map;
        final vendor = config['vendor'] as String?;
        final auth = config['auth'] as String?;

        if (vendor != null && auth != null && !_isCompatible(vendor, auth)) {
          errors.add('Incompatible configuration: $vendor with $auth');
        }
      } catch (e) {
        errors.add('Invalid config.yaml: $e');
      }
    }

    // Validate pubspec.yaml
    final pubspecPath = p.join(projectPath, 'pubspec.yaml');
    if (File(pubspecPath).existsSync()) {
      try {
        final content = File(pubspecPath).readAsStringSync();
        final pubspec = loadYaml(content) as Map;

        // Check for required dependencies â€” accept any valid dartstream core package
        final deps = pubspec['dependencies'] as Map?;
        final validCoreDeps = [
          'ds_standard_engine',
          'ds_standard_features',
          'ds_dartstream_standard_engine',
        ];
        final hasCoreDep =
            deps != null && validCoreDeps.any((dep) => deps.containsKey(dep));
        if (!hasCoreDep) {
          errors.add(
            'Missing required Dartstream dependency (expected one of: ${validCoreDeps.join(', ')})',
          );
        }
      } catch (e) {
        errors.add('Invalid pubspec.yaml: $e');
      }
    }

    if (errors.isNotEmpty) {
      print('Project validation failed:');
      for (final e in errors) {
        print('  - $e');
      }
      return false;
    }

    print('Project structure valid.');
    return true;
  }

  /// Resolves the project directory path by trying multiple locations.
  String _resolveProjectPath(String projectName, String dartstreamRoot) {
    final paths = [
      // Bare name (user cd'd into projects/)
      projectName,
      // Relative to cwd
      p.join('projects', projectName),
      p.join('..', 'projects', projectName),
      p.join('..', '..', 'projects', projectName),
      p.join('..', '..', '..', 'projects', projectName),
      // Root-relative path (works regardless of cwd depth)
      p.join(dartstreamRoot, 'projects', projectName),
    ];

    for (final path in paths) {
      if (Directory(path).existsSync()) {
        return path;
      }
    }

    // Default to root-relative
    return p.join(dartstreamRoot, 'projects', projectName);
  }

  Future<void> _validateExtensions(String levelFilter, bool strictMode) async {
    print('\nValidating extensions...');

    final extensionsDir = _findExtensionsDirectory();
    final registryFile = _findRegistryFile();

    if (!Directory(extensionsDir).existsSync()) {
      print('Extensions directory not found');
      return;
    }

    try {
      final registry = ExtensionRegistry(
        extensionsDirectory: extensionsDir,
        registryFile: registryFile,
      );

      registry.discoverExtensions();

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
          hasErrors = true;
          print('  FAIL ${extension.name}');
          for (final err in result.errors) {
            print('    - $err');
          }
        } else {
          print('  OK ${extension.name}');
        }

        if (strictMode && result.warnings.isNotEmpty) {
          for (final warning in result.warnings) {
            print('    WARN $warning');
          }
        }
      }

      if (!hasErrors) {
        print('All extensions valid.');
      } else {
        print('Some extensions have errors.');
      }
    } catch (e) {
      print('Error validating extensions: $e');
    }
  }

  ValidationResult _validateExtension(
    ExtensionManifest extension,
    ExtensionRegistry registry,
    bool strictMode,
  ) {
    final result = ValidationResult();

    if (extension.name.isEmpty) {
      result.addError('Missing name');
    }

    if (!_isValidVersion(extension.version)) {
      result.addError('Invalid version format: ${extension.version}');
    }

    if (!registry.validateDependencies(extension)) {
      result.addError('Dependency validation failed');
    }

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

  void _validateProviderCode(
    String filePath,
    ExtensionManifest extension,
    ValidationResult result,
  ) {
    try {
      final content = File(filePath).readAsStringSync();
      if (!content.contains('///')) {
        result.addWarning('Missing documentation comments');
      }
      if (!content.contains('try') && !content.contains('catch')) {
        result.addWarning('No error handling found');
      }
      if (extension.name.contains('auth_provider')) {
        if (!content.contains('extends DSAuthProvider') &&
            !content.contains('implements DSAuthProvider')) {
          result.addWarning(
            'Auth provider should extend or implement DSAuthProvider',
          );
        }
      }
    } catch (e) {
      result.addError('Failed to analyze code: $e');
    }
  }

  Future<void> _validateProviders() async {
    print('\nðŸ”Œ Validating providers...');

    // Use dartstream root for reliable path resolution
    final dartstreamRoot = _findDartstreamRoot();

    final providersPath = p.join(
      dartstreamRoot,
      'packages',
      'standard',
      'standard_extensions',
      'auth',
      'providers',
    );

    if (!Directory(providersPath).existsSync()) {
      print('Providers directory not found');
      return;
    }

    final providers = Directory(providersPath)
        .listSync()
        .whereType<Directory>()
        .map((dir) => p.basename(dir.path))
        .toList();

    print('Found ${providers.length} auth providers:');

    for (final provider in providers) {
      final pubspecPath = p.join(providersPath, provider, 'pubspec.yaml');
      if (!File(pubspecPath).existsSync()) {
        print('  FAIL $provider: Missing pubspec.yaml');
        continue;
      }

      try {
        final pubspec = loadYaml(File(pubspecPath).readAsStringSync()) as Map;
        final version = pubspec['version'] as String? ?? 'unknown';
        if (version.contains('pre')) {
          print('  WARN $provider: $version (pre-release)');
        } else {
          print('  OK $provider: $version');
        }
      } catch (_) {
        print('  FAIL $provider: Invalid pubspec');
      }
    }
  }

  Future<void> _validateManifestAndPrefixStandards() async {
    print('\nRunning prefix and manifest checks...');

    final root = Directory.current;
    final manifests = <File>[];

    await for (final entity in root.list(recursive: true, followLinks: false)) {
      if (entity is File && p.basename(entity.path) == 'manifest.yaml') {
        manifests.add(entity);
      }
    }

    var failures = 0;

    for (final manifestFile in manifests) {
      final raw = loadYaml(await manifestFile.readAsString());
      if (raw is! YamlMap) continue;

      final name = (raw['name'] as String?) ?? '';
      final type = (raw['type'] as String?) ?? '';
      final hasOptional = raw.containsKey('optional');
      final hasCompatible =
          raw.containsKey('compatible') || raw.containsKey('compatible_with');

      if (!name.startsWith('ds_') &&
          !name.startsWith('ds_plugin_') &&
          !name.startsWith('custom_')) {
        print(
          '  FAIL ${manifestFile.path}: name prefix does not match standards',
        );
        failures++;
      }

      if (type.isEmpty) {
        print('  FAIL ${manifestFile.path}: missing type');
        failures++;
      }

      if (!hasOptional) {
        print('  FAIL ${manifestFile.path}: missing optional');
        failures++;
      }

      if (!hasCompatible) {
        print(
          '  FAIL ${manifestFile.path}: missing compatible/compatible_with',
        );
        failures++;
      }
    }

    if (failures == 0) {
      print('Prefix and manifest checks passed.');
    } else {
      print('Prefix and manifest checks found $failures issue(s).');
    }
  }

  bool _isValidVersion(String version) {
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
    // Use dartstream root for reliable resolution
    final dartstreamRoot = _findDartstreamRoot();

    final paths = [
      p.join('packages'),
      p.join('packages', 'standard', 'standard_extensions'),
      p.join(
        '..',
        'dartstream_backend',
        'packages',
        'standard',
        'standard_extensions',
      ),
      // Root-relative path (works regardless of cwd depth)
      p.join(dartstreamRoot, 'packages', 'standard', 'standard_extensions'),
    ];

    for (final path in paths) {
      final fullPath = p.normalize(p.join(Directory.current.path, path));
      if (Directory(fullPath).existsSync()) {
        return fullPath;
      }
    }

    // Default to root-relative
    return p.normalize(
      p.join(dartstreamRoot, 'packages', 'standard', 'standard_extensions'),
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
