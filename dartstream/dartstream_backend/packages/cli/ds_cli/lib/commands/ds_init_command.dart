import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:ds_cli_util/ds_cli_utils.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

class DSInitCommand extends Command {
  @override
  final name = 'init';
  @override
  final description =
      'Initialize a new Dartstream project with standard engine.';

  DSInitCommand() {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        defaultsTo: '',
        help: 'Project name (use underscores, no spaces).',
      )
      ..addOption(
        'version',
        abbr: 'v',
        defaultsTo: 'stable',
        allowed: ['stable', 'beta'],
        help: 'Framework version (stable: 0.0.1, beta: pre-release).',
      )
      ..addOption(
        'framework',
        abbr: 'f',
        defaultsTo: '',
        allowed: [
          'dart_web',
          'flutter_web',
          'flutter_mobile',
          'flutter_desktop',
          'vue',
          'svelte',
        ],
        help: 'Target framework.',
      );
  }

  @override
  void run() {
    execute();
  }

  void execute({String Function()? readLineCallback}) {
    print('🚀 Initializing Dartstream project...');

    var name = argResults?['name'];
    var version = argResults?['version'] ?? 'stable';
    var framework = argResults?['framework'];

    var read = readLineCallback ?? stdin.readLineSync;

    // Get project name
    if (name.isEmpty) {
      stdout.write('Enter project name (use underscores, no spaces): ');
      name = read() ?? '';
    }

    // Sanitize project name
    name = sanitizeProjectName(name);

    if (!isValidDartIdentifier(name)) {
      print('❌ Error: "$name" is not a valid Dart identifier.');
      print(
        '   Project names must start with a letter and contain only letters, numbers, and underscores.',
      );
      return;
    }

    // Find dartstream root and create in projects folder
    final dartstreamRoot = _findDartstreamRoot();
    final projectsDir = Directory(p.join(dartstreamRoot, 'projects'));
    if (!projectsDir.existsSync()) {
      projectsDir.createSync();
    }

    final projectPath = p.join(projectsDir.path, name);
    final projectDir = Directory(projectPath);

    if (projectDir.existsSync()) {
      print('❌ Project "$name" already exists at: $projectPath');
      return;
    }

    // Get framework if not specified
    if (framework == null || framework.isEmpty) {
      print('\nSelect framework:');
      print('1. Dart Web');
      print('2. Flutter Web');
      print('3. Flutter Mobile');
      print('4. Flutter Desktop');
      print('5. Vue.js');
      print('6. Svelte');
      stdout.write('Choice (1-6): ');

      final choice = read() ?? '1';
      framework = parseFramework(choice);
    }

    // Create project structure
    createProjectWithEngine(
      projectPath: projectPath,
      name: name,
      version: version,
      framework: framework,
    );

    print('✅ Project "$name" initialized successfully!');
    print('   Location: $projectPath');
    print('   Version: $version');
    print('   Framework: $framework');
    print('\nNext steps:');
    print('  cd $projectPath');
    print('  dart pub get');
    print('  dart run dartstream configure');
  }

  String _findDartstreamRoot() {
    // Look for dartstream root directory
    var currentDir = Directory.current.path;

    // Check if we're already in dartstream root
    if (currentDir.endsWith('dartstream')) {
      return currentDir;
    }

    // Check if we're in a subdirectory of dartstream
    final parts = currentDir.split('/');
    for (int i = parts.length - 1; i >= 0; i--) {
      if (parts[i] == 'dartstream') {
        return parts.sublist(0, i + 1).join('/');
      }
    }

    // Default to current directory's parent until we find dartstream
    return p.normalize(p.join(currentDir, '..', '..', '..', '..'));
  }

  String sanitizeProjectName(String name) {
    // Replace spaces and hyphens with underscores
    return name.replaceAll(RegExp(r'[\s\-]'), '_').toLowerCase();
  }

  bool isValidDartIdentifier(String name) {
    // Must start with letter or underscore, contain only letters, numbers, underscores
    final pattern = RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$');
    return pattern.hasMatch(name);
  }

  String parseFramework(String choice) {
    switch (choice) {
      case '1':
        return 'dart_web';
      case '2':
        return 'flutter_web';
      case '3':
        return 'flutter_mobile';
      case '4':
        return 'flutter_desktop';
      case '5':
        return 'vue';
      case '6':
        return 'svelte';
      default:
        return 'dart_web';
    }
  }

  void createProjectWithEngine({
    required String projectPath,
    required String name,
    required String version,
    required String framework,
  }) {
    print('📦 Creating project structure with Standard Engine...');

    final projectDir = Directory(projectPath);
    projectDir.createSync(recursive: true);

    // Create standard directories
    Directory('${projectDir.path}/lib').createSync();
    Directory('${projectDir.path}/lib/src').createSync();
    Directory('${projectDir.path}/lib/src/core').createSync();
    Directory('${projectDir.path}/lib/src/extensions').createSync();
    Directory('${projectDir.path}/test').createSync();
    Directory('${projectDir.path}/config').createSync();

    // Create main.dart with Standard Engine initialization
    File('${projectDir.path}/lib/main.dart').writeAsStringSync('''
import 'package:ds_standard_engine/ds_standard_engine.dart';
import 'src/core/app_core.dart';

void main() async {
  // Initialize Dartstream Standard Engine
  final core = DSStandardCore(
    projectConfig: {
      'name': '$name',
      'version': '$version',
      'framework': '$framework',
      'created': DateTime.now().toIso8601String(),
    },
  );

  await core.initialize();
  
  // Initialize app-specific core
  final app = AppCore(core: core);
  await app.start();
  
  print('🚀 $name is running with Dartstream!');
}
''');

    // Create app_core.dart
    File('${projectDir.path}/lib/src/core/app_core.dart').writeAsStringSync('''
import 'package:ds_standard_engine/ds_standard_engine.dart';

class AppCore {
  final DSStandardCore core;
  
  AppCore({required this.core});
  
  Future<void> start() async {
    // Register your extensions here
    await registerExtensions();
    
    // Start the framework
    core.start();
  }
  
  Future<void> registerExtensions() async {
    // Extensions will be auto-discovered and registered
    // You can manually register additional extensions here
  }
}
''');

    // Create pubspec.yaml with correct dependencies
    final isPreRelease = version == 'beta';
    final versionSuffix = isPreRelease ? '-pre' : '';

    File('${projectDir.path}/pubspec.yaml').writeAsStringSync('''
name: $name
description: A Dartstream project with Standard Engine.
version: 0.0.1
publish_to: none

environment:
  sdk: ^3.8.0

dependencies:
  # Core Dartstream packages
  ds_standard_engine: ^0.0.1
  ds_standard_features: ^0.0.4
  
  # Framework-specific dependencies
${getFrameworkDependencies(framework, isPreRelease)}
  
  # Standard utilities
  path: ^1.9.0
  yaml: ^3.1.0

dev_dependencies:
  test: ^1.25.0
  lints: ^4.0.0
''');

    // Create analysis_options.yaml
    File('${projectDir.path}/analysis_options.yaml').writeAsStringSync('''
include: package:lints/recommended.yaml

linter:
  rules:
    prefer_single_quotes: true
    prefer_final_locals: true
    avoid_print: false
''');

    // Create README.md
    File('${projectDir.path}/README.md').writeAsStringSync('''
# $name

A Dartstream project built with the Standard Engine.

## Getting Started

1. Install dependencies:
   ```bash
   dart pub get
   ```

2. Configure your project:
   ```bash
   dart run dartstream configure
   ```

3. Run the application:
   ```bash
   dart run lib/main.dart
   ```

## Framework

This project uses **$framework** with Dartstream Standard Engine.

## Version

Running on Dartstream ${version == 'beta' ? 'Beta (pre-release)' : 'Stable'} version.
''');

    // Save initial configuration
    saveProjectConfig(
      name: name,
      content: {
        'name': name,
        'version': version,
        'framework': framework,
        'engine': 'standard',
        'created': DateTime.now().toIso8601String(),
      },
    );

    // Copy framework template if it exists
    copyFrameworkTemplate(framework, projectDir.path);
  }

  String getFrameworkDependencies(String framework, bool isPreRelease) {
    final suffix = isPreRelease ? '-pre' : '';

    switch (framework) {
      case 'flutter_web':
      case 'flutter_mobile':
      case 'flutter_desktop':
        return '''
  flutter:
    sdk: flutter
  # ds_flutter_mobile: ^0.0.1$suffix  # Uncomment when published''';

      case 'dart_web':
        return '''
  shelf: ^1.4.0
  shelf_router: ^1.1.0
  # ds_shelf: ^0.0.1$suffix  # Uncomment when published''';

      case 'vue':
      case 'svelte':
        return '''
  # Frontend framework integration
  shelf: ^1.4.0
  shelf_static: ^1.1.0''';

      default:
        return '  # No framework-specific dependencies';
    }
  }

  void copyFrameworkTemplate(String framework, String projectPath) {
    // Path to framework templates
    final templatePath = p.join(
      Directory.current.path,
      'packages',
      'frameworks',
      framework.replaceAll('_', '_'),
    );

    final templateDir = Directory(templatePath);
    if (templateDir.existsSync()) {
      print('📋 Copying $framework template...');
      // Copy template files (simplified - in production use proper file copying)
      // This would copy the framework-specific files from packages/frameworks/
    }
  }
}
