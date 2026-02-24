import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:args/command_runner.dart';
import 'package:ds_discovery_provider/main.dart';
import 'package:yaml/yaml.dart';

/// CLI Command for Dartstream to discover and manage extensions dynamically.
class DSDiscoveryCommand extends Command {
  @override
  final name = 'discover';

  @override
  final description =
      'Discovers, validates, and dynamically registers extensions with Standard Engine.';

  DSDiscoveryCommand() {
    argParser
      ..addOption(
        'project',
        abbr: 'p',
        help: 'Project name to discover extensions for.',
      )
      ..addFlag(
        'register',
        abbr: 'r',
        help: 'Automatically register discovered extensions.',
        defaultsTo: true,
      )
      ..addFlag(
        'validate',
        abbr: 'v',
        help: 'Validate extensions before registration.',
        defaultsTo: true,
      );
  }

  @override
  Future<void> run() async {
    final projectName = argResults?['project'] as String?;
    final shouldRegister = argResults?['register'] as bool;
    final shouldValidate = argResults?['validate'] as bool;

    print('🔍 Starting extension discovery...\n');

    // Find extensions directory
    final extensionsDirectory = _findExtensionsDirectory();
    final registryFile = _findRegistryFile();

    print('📁 Extensions directory: $extensionsDirectory');
    print('📋 Registry file: $registryFile');

    if (!Directory(extensionsDirectory).existsSync()) {
      print('❌ Extensions directory not found.');
      return;
    }

    try {
      // Create registry instance
      final registry = ExtensionRegistry(
        extensionsDirectory: extensionsDirectory,
        registryFile: registryFile,
      );

      // Discover extensions
      registry.discoverExtensions();

      print('\n📦 Discovered extensions:');
      _printExtensions(registry);

      // Validate if requested
      if (shouldValidate) {
        print('\n✅ Validating extensions...');
        _validateExtensions(registry);
      }

      // Register with Standard Engine if requested
      if (shouldRegister && projectName != null) {
        print('\n🔧 Registering with Standard Engine...');
        await _registerWithEngine(registry, projectName);
      }

      // Initialize lifecycle hooks
      print('\n🎯 Initializing lifecycle hooks...');
      for (final extension in registry.extensions) {
        extension.onInitialize();
          print('   ✓ ${extension.name} initialized');
      }

      print('\n✅ Discovery complete!');
    } catch (e) {
      print('❌ Error during discovery: $e');
    }
  }

  String _findExtensionsDirectory() {
    // Try multiple possible paths
    final paths = [
      // From ds_cli folder, go up 3 levels
      p.join('..', '..', '..', 'packages', 'standard', 'standard_extensions'),
      p.join('..', '..', 'standard', 'standard_extensions'),
      // Absolute from project root
      p.join('packages', 'standard', 'standard_extensions'),
      // Legacy paths for compatibility
      p.join('packages', 'standard', 'extensions'),
    ];

    for (final path in paths) {
      final fullPath = p.normalize(p.join(Directory.current.path, path));
      if (Directory(fullPath).existsSync()) {
        return fullPath;
      }
    }

    // Default to the correct path even if not found
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
      p.join('..', '..', 'dartstream_registry.yaml'),
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

  void _printExtensions(ExtensionRegistry registry) {
    // Core extensions
    if (registry.coreExtensions.isNotEmpty) {
      print('\n  Core Extensions:');
      for (final ext in registry.coreExtensions) {
        print('    • ${ext.name} (${ext.version})');
      }
    }

    // Extended features
    if (registry.extendedFeatures.isNotEmpty) {
      print('\n  Extended Features:');
      for (final ext in registry.extendedFeatures) {
        final core = ext.coreExtension != null
            ? ' for ${ext.coreExtension}'
            : '';
        print('    • ${ext.name} (${ext.version})$core');
      }
    }

    // Third-party enhancements
    if (registry.thirdPartyEnhancements.isNotEmpty) {
      print('\n  Third-Party Enhancements:');
      for (final ext in registry.thirdPartyEnhancements) {
        print('    • ${ext.name} (${ext.version})');
      }
    }

    print('\n  Total: ${registry.extensions.length} extensions');
  }

  void _validateExtensions(ExtensionRegistry registry) {
    var hasErrors = false;

    for (final extension in registry.extensions) {
      final errors = <String>[];

      // Validate required fields
      if (extension.name.isEmpty) errors.add('Missing name');
      if (extension.version.isEmpty) errors.add('Missing version');
      if (extension.entryPoint.isEmpty) errors.add('Missing entry point');

      // Validate dependencies
      if (!registry.validateDependencies(extension)) {
        errors.add('Dependency validation failed');
      }

      // Check entry point exists
      final entryPointPath = p.join(
        registry.extensionsDirectory,
        extension.entryPoint,
      );
      if (!File(entryPointPath).existsSync()) {
        errors.add('Entry point not found: ${extension.entryPoint}');
      }

      if (errors.isNotEmpty) {
        print('   ✗ ${extension.name}: ${errors.join(', ')}');
        hasErrors = true;
      } else {
        print('   ✓ ${extension.name}: Valid');
      }
    }

    if (hasErrors) {
      print('\n⚠️  Some extensions have validation errors.');
    } else {
      print('\n✅ All extensions validated successfully.');
    }
  }

  Future<void> _registerWithEngine(
    ExtensionRegistry registry,
    String projectName,
  ) async {
    // Load project configuration
    final configPath = p.join(projectName, 'config.yaml');
    if (!File(configPath).existsSync()) {
      print(
        '⚠️  Project configuration not found. Run "dartstream configure" first.',
      );
      return;
    }

    final configContent = File(configPath).readAsStringSync();
    loadYaml(configContent);

    // Generate registration code
    final registrationPath = p.join(
      projectName,
      'lib',
      'src',
      'extensions',
      'auto_register.dart',
    );
    final registrationFile = File(registrationPath);
    registrationFile.createSync(recursive: true);

    final buffer = StringBuffer();
    buffer.writeln('// Auto-generated extension registration');
    buffer.writeln('// Generated by Dartstream Discovery');
    buffer.writeln('');
    buffer.writeln(
      'import \'package:ds_standard_engine/ds_standard_engine.dart\';',
    );

    // Add imports for active extensions
    for (final ext in registry.activeExtensions) {
      final extension = registry.extensions.firstWhere((e) => e.name == ext);
      if (extension.level == ExtensionLevel.core) {
        buffer.writeln('// import \'package:${ext}/${ext}.dart\';');
      }
    }

    buffer.writeln('');
    buffer.writeln(
      'Future<void> autoRegisterExtensions(DSStandardCore core) async {',
    );
    buffer.writeln('  print(\'🔌 Auto-registering extensions...\');');
    buffer.writeln('  ');

    // Generate registration code for each active extension
    for (final ext in registry.activeExtensions) {
      final extension = registry.extensions.firstWhere((e) => e.name == ext);

      if (extension.level == ExtensionLevel.core) {
        buffer.writeln('  // Register ${extension.name}');
        buffer.writeln('  // core.registerCoreExtension(');
        buffer.writeln('  //   extension: ${_getClassName(extension.name)}(),');
        buffer.writeln(
          '  //   baseFeature: \'${_getBaseFeature(extension.name)}\',',
        );
        buffer.writeln('  // );');
        buffer.writeln('  ');
      }
    }

    buffer.writeln(
      '  print(\'✅ Extensions registered: ${registry.activeExtensions.length}\');',
    );
    buffer.writeln('}');

    registrationFile.writeAsStringSync(buffer.toString());
    print('   ✓ Registration code generated: auto_register.dart');
  }

  String _getClassName(String extensionName) {
    // Convert extension name to class name
    // ds_firebase_auth_provider -> DSFirebaseAuthProvider
    return extensionName
        .split('_')
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join('');
  }

  String _getBaseFeature(String extensionName) {
    // Determine base feature from extension name
    if (extensionName.contains('auth')) return 'authentication';
    if (extensionName.contains('database')) return 'database';
    if (extensionName.contains('storage')) return 'storage';
    if (extensionName.contains('middleware')) return 'middleware';
    if (extensionName.contains('feature_flag')) return 'feature_flags';
    return 'unknown';
  }
}
