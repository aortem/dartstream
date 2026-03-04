import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:args/command_runner.dart';
import 'package:ds_discovery_provider/main.dart';
import 'package:yaml/yaml.dart';

/// CLI command to discover and manage extensions dynamically.
class DSDiscoveryCommand extends Command {
  @override
  final name = 'discover';

  @override
  final description =
      'Discovers, validates, and registers extensions from standard and enhanced directories.';

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

    print('Starting extension discovery...');

    final extensionsDirectory = _findExtensionsDirectory();
    final registryFile = _findRegistryFile();

    print('Extensions directory: $extensionsDirectory');
    print('Registry file: $registryFile');

    if (!Directory(extensionsDirectory).existsSync()) {
      print('Extensions directory not found.');
      return;
    }

    try {
      final registry = ExtensionRegistry(
        extensionsDirectory: extensionsDirectory,
        registryFile: registryFile,
      );

      registry.discoverExtensions();

      print('\nDiscovered extensions:');
      _printExtensions(registry);

      if (shouldValidate) {
        print('\nValidating extensions...');
        _validateExtensions(registry);
      }

      if (shouldRegister && projectName != null) {
        print('\nRegistering with Standard Engine...');
        await _registerWithEngine(registry, projectName);
      }

      print('\nInitializing lifecycle hooks...');
      for (final extension in registry.extensions) {
        extension.onInitialize();
          print('   ✓ ${extension.name} initialized');
      }

      print('\nDiscovery complete.');
    } catch (e) {
      print('Error during discovery: $e');
    }
  }

  String _findExtensionsDirectory() {
    final paths = [
      // Prefer packages root so both standard and enhanced/plugins are included.
      p.join('packages'),
      p.join('..', '..', '..', 'packages'),
      p.join('packages', 'standard', 'standard_extensions'),
      p.join('packages', 'enhanced', 'plugins'),
      p.join('packages', 'standard', 'extensions'),
    ];

    for (final path in paths) {
      final fullPath = p.normalize(p.join(Directory.current.path, path));
      if (Directory(fullPath).existsSync()) {
        return fullPath;
      }
    }

    return p.normalize(p.join(Directory.current.path, 'packages'));
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

    return p.normalize(p.join(Directory.current.path, 'dartstream_registry.yaml'));
  }

  void _printExtensions(ExtensionRegistry registry) {
    if (registry.coreExtensions.isNotEmpty) {
      print('\n  Core Extensions:');
      for (final ext in registry.coreExtensions) {
        print('    - ${ext.name} (${ext.version})');
      }
    }

    if (registry.extendedFeatures.isNotEmpty) {
      print('\n  Extended Features:');
      for (final ext in registry.extendedFeatures) {
        final core = ext.coreExtension != null ? ' for ${ext.coreExtension}' : '';
        print('    - ${ext.name} (${ext.version})$core');
      }
    }

    if (registry.thirdPartyEnhancements.isNotEmpty) {
      print('\n  Third-Party Enhancements:');
      for (final ext in registry.thirdPartyEnhancements) {
        print('    - ${ext.name} (${ext.version})');
      }
    }

    print('\n  Total: ${registry.extensions.length} extensions');
  }

  void _validateExtensions(ExtensionRegistry registry) {
    var hasErrors = false;

    for (final extension in registry.extensions) {
      final errors = <String>[];

      if (extension.name.isEmpty) errors.add('Missing name');
      if (extension.version.isEmpty) errors.add('Missing version');
      if (extension.entryPoint.isEmpty) errors.add('Missing entry point');

      if (!registry.validateDependencies(extension)) {
        errors.add('Dependency validation failed');
      }

      final entryPointPath = p.join(registry.extensionsDirectory, extension.entryPoint);
      if (!File(entryPointPath).existsSync()) {
        errors.add('Entry point not found: ${extension.entryPoint}');
      }

      if (errors.isNotEmpty) {
        print('  FAIL ${extension.name}: ${errors.join(', ')}');
        hasErrors = true;
      } else {
        print('  OK ${extension.name}: Valid');
      }
    }

    if (hasErrors) {
      print('\nSome extensions have validation errors.');
    } else {
      print('\nAll extensions validated successfully.');
    }
  }

  Future<void> _registerWithEngine(
    ExtensionRegistry registry,
    String projectName,
  ) async {
    final configPath = p.join(projectName, 'config.yaml');
    if (!File(configPath).existsSync()) {
      print('Project configuration not found. Run "dartstream configure" first.');
      return;
    }

    final configContent = File(configPath).readAsStringSync();
    loadYaml(configContent);

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
    buffer.writeln('import \'package:ds_standard_engine/ds_standard_engine.dart\';');
    buffer.writeln('');
    buffer.writeln('Future<void> autoRegisterExtensions(DSStandardCore core) async {');
    buffer.writeln('  print(\'Auto-registering extensions...\');');
    buffer.writeln('');

    for (final ext in registry.activeExtensions) {
      final extension = registry.extensions.firstWhere((e) => e.name == ext);
      if (extension.level == ExtensionLevel.core) {
        buffer.writeln('  // Register ${extension.name}');
        buffer.writeln('  // core.registerCoreExtension(');
        buffer.writeln('  //   extension: ${_getClassName(extension.name)}(),');
        buffer.writeln('  //   baseFeature: \'${_getBaseFeature(extension.name)}\',');
        buffer.writeln('  // );');
        buffer.writeln('');
      }
    }

    buffer.writeln('  print(\'Extensions registered: ${registry.activeExtensions.length}\');');
    buffer.writeln('}');

    registrationFile.writeAsStringSync(buffer.toString());
    print('  OK Registration code generated: auto_register.dart');
  }

  String _getClassName(String extensionName) {
    return extensionName
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join('');
  }

  String _getBaseFeature(String extensionName) {
    if (extensionName.contains('auth')) return 'authentication';
    if (extensionName.contains('database')) return 'database';
    if (extensionName.contains('storage')) return 'storage';
    if (extensionName.contains('middleware')) return 'middleware';
    if (extensionName.contains('feature_flag')) return 'feature_flags';
    return 'unknown';
  }
}
