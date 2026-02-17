import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;

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
        'type',
        abbr: 't',
        defaultsTo: '',
        allowed: [
          'new',
          'existing-dartstream',
          'migrate-vue',
          'migrate-svelte',
          'migrate-flutter-web',
          'migrate-flutter-mobile',
          'migrate-dart-web',
        ],
        help: 'Project type.',
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
          'flutter_games',
          'vue',
          'svelte',
        ],
        help: 'Target framework.',
      )
      ..addOption(
        'middleware',
        abbr: 'm',
        defaultsTo: '',
        allowed: ['dartstream', 'shelf', 'custom'],
        help: 'Middleware type.',
      );
  }

  @override
  void run() {
    execute();
  }

  void execute({String? Function()? readLineCallback}) {
    print('ðŸš€ Initializing Dartstream project...\n');

    var name = argResults?['name'];
    var version = argResults?['version'] ?? 'stable';
    var projectType = argResults?['type'];
    var framework = argResults?['framework'];
    var middleware = argResults?['middleware'];

    var read = readLineCallback ?? stdin.readLineSync;

    // Step 1: Get project name
    if (name.isEmpty) {
      stdout.write('Enter Project Name: ');
      name = read() ?? '';
    }

    // Sanitize and validate project name
    name = sanitizeProjectName(name);

    if (!isValidDartIdentifier(name)) {
      print('âŒ Error: "$name" is not a valid Dart identifier.');
      print(
        '   Project names must start with a letter and contain only letters, numbers, and underscores.',
      );
      return;
    }

    // Step 2: Version selection
    if (argResults?['version'] == null) {
      print('\nSelect Version:');
      print('1. Open-Source Version (Stable)');
      print('2. Open-Source Version (Beta)');
      stdout.write('Choice (1-2): ');

      final versionChoice = read() ?? '1';
      version = versionChoice == '2' ? 'beta' : 'stable';
    }

    // Step 3: Project type selection
    if (projectType == null || projectType.isEmpty) {
      print('\nChoose your project type:');
      print('1. New Project (from scratch)');
      print('2. Existing Project (import existing setup)');
      stdout.write('Choice (1-2): ');

      final typeChoice = read() ?? '1';

      if (typeChoice == '2') {
        print('\n  Select existing project type:');
        print('  2a. Existing project previously created with Dartstream');
        print(
          '  2b. Existing external project - migration to Dartstream (vue, flutterweb)',
        );
        print(
          '  2c. Existing external project - migration to Dartstream **CLOUD ONLY**',
        );
        print(
          '      (vue, svelte, flutterweb, flutter mobile, dartweb, flutter desktop, Flutter Games)',
        );
        stdout.write('  Choice (a-c): ');

        final subChoice = read()?.toLowerCase() ?? 'a';

        switch (subChoice) {
          case 'a':
            projectType = 'existing-dartstream';
            break;
          case 'b':
          case 'c':
            if (version == 'stable' && subChoice == 'c') {
              print(
                '\nâš ï¸  Migration features are available in CLOUD version only',
              );
              print('   Starting new project instead.');
              projectType = 'new';
            } else {
              projectType = _getMigrationType(read);
            }
            break;
          default:
            projectType = 'new';
        }
      } else {
        projectType = 'new';
      }
    }

    // Step 4: Framework selection
    if (framework == null || framework.isEmpty) {
      print('\nSelect your frontend framework:');
      print('1. Dart Web');
      print('2. Flutter Web');
      print('3. Flutter (mobile)');
      print('4. Flutter Desktop');
      print('5. Flutter Games');
      print('6. Vue.js');
      print('7. Svelte');
      stdout.write('Choice (1-7): ');

      final choice = read() ?? '2';
      framework = _mapFrameworkChoice(choice);
    }

    // Step 5: Middleware selection
    if (middleware == null || middleware.isEmpty) {
      print('\nChoose Middleware:');
      print('1. Dartstream Middleware (default)');
      print('2. Shelf Middleware');
      print(
        '3. Custom Middleware (start from scratch OR use a partner extension)',
      );
      stdout.write('Choice (1-3): ');

      final choice = read() ?? '1';
      middleware = _mapMiddlewareChoice(choice);
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
      print('\nâŒ Project "$name" already exists at: $projectPath');
      stdout.write('Overwrite? (y/N): ');
      final overwrite = read()?.toLowerCase() ?? 'n';
      if (overwrite != 'y') {
        print('Project initialization cancelled.');
        return;
      }
      projectDir.deleteSync(recursive: true);
    }

    // Create project
    print('\nðŸ”¨ Creating project structure...');
    createProjectWithEngine(
      projectPath: projectPath,
      name: name,
      framework: framework,
      version: version,
      middleware: middleware,
      projectType: projectType,
    );

    // Save project configuration
    _saveProjectConfig(
      projectPath,
      name,
      version,
      projectType,
      framework,
      middleware,
    );

    print('\nâœ… Project "$name" initialized successfully!');
    print('\nðŸ“ Project location: $projectPath');
    print('\nNext steps:');
    print('1. cd $projectPath');
    print(
      '2. dartstream configure   # Configure cloud vendor, auth, and database',
    );
    print('3. dart pub get           # Install dependencies');
    print('4. dart run               # Start your server');
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

  void createProjectWithEngine({
    required String projectPath,
    required String name,
    required String framework,
    required String version,
    String? middleware,
    String? projectType,
  }) {
    print('ðŸ“¦ Creating project structure with Standard Engine...');

    final projectDir = Directory(projectPath);
    projectDir.createSync(recursive: true);

    // Create standard directories
    Directory('$projectPath/lib').createSync();
    Directory('$projectPath/lib/src').createSync();
    Directory('$projectPath/lib/src/core').createSync();
    Directory('$projectPath/lib/src/extensions').createSync();
    Directory('$projectPath/lib/src/middleware').createSync();
    Directory('$projectPath/test').createSync();
    Directory('$projectPath/config').createSync();
    Directory('$projectPath/bin').createSync();
    Directory('$projectPath/web').createSync();
    Directory('$projectPath/web/assets').createSync();

    // Create main.dart
    File('$projectPath/lib/main.dart').writeAsStringSync('''
void main() {
  print('Welcome to Dartstream!');
  print('Framework: $framework');
  print('Middleware: ${middleware ?? 'dartstream'}');
  
  // Run: dart run dartstream configure
  // to set up cloud vendor, auth, and database
}
''');

    // Create pubspec.yaml
    final middlewarePackage = middleware == 'shelf'
        ? 'ds_shelf: ^0.0.1-pre+4'
        : 'ds_custom_middleware: ^0.0.1-pre';

    File('$projectPath/pubspec.yaml').writeAsStringSync('''
name: $name
description: A DartStream project
version: 0.1.0

environment:
  sdk: ^3.11.0

dependencies:
  # DartStream core
  ds_standard_features: ^0.1.6
  $middlewarePackage
  
  # Add your dependencies here

dev_dependencies:
  lints: ^4.0.0
  test: ^1.25.0
''');

    // Create README
    File('$projectPath/README.md').writeAsStringSync('''
# $name

A DartStream project using $framework with ${middleware ?? 'dartstream'} middleware.

## Getting Started

1. Configure your project:
   ```bash
   dart run dartstream configure
   ```

2. Install dependencies:
   ```bash
   dart pub get
   ```

3. Run your application:
   ```bash
   dart run
   ```
''');
  }

  String _mapFrameworkChoice(String choice) {
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
        return 'flutter_games';
      case '6':
        return 'vue';
      case '7':
        return 'svelte';
      default:
        return 'flutter_web';
    }
  }

  String _mapMiddlewareChoice(String choice) {
    switch (choice) {
      case '1':
        return 'dartstream';
      case '2':
        return 'shelf';
      case '3':
        return 'custom';
      default:
        return 'dartstream';
    }
  }

  String _getMigrationType(String? Function() read) {
    print('\n  Select migration source:');
    print('  1. Vue.js');
    print('  2. Svelte');
    print('  3. Flutter Web');
    print('  4. Flutter Mobile');
    print('  5. Dart Web');
    print('  6. Flutter Desktop');
    print('  7. Flutter Games');
    stdout.write('  Choice (1-7): ');

    final choice = read() ?? '1';
    switch (choice) {
      case '1':
        return 'migrate-vue';
      case '2':
        return 'migrate-svelte';
      case '3':
        return 'migrate-flutter-web';
      case '4':
        return 'migrate-flutter-mobile';
      case '5':
        return 'migrate-dart-web';
      case '6':
        return 'migrate-flutter-desktop';
      case '7':
        return 'migrate-flutter-games';
      default:
        return 'new';
    }
  }

  String _findDartstreamRoot() {
    var currentDir = Directory.current;
    while (!Directory(p.join(currentDir.path, 'packages')).existsSync()) {
      final parent = currentDir.parent;
      if (parent.path == currentDir.path) {
        // Reached root, default to current directory
        return Directory.current.path;
      }
      currentDir = parent;
    }
    return currentDir.path;
  }

  void _saveProjectConfig(
    String projectPath,
    String name,
    String version,
    String projectType,
    String framework,
    String middleware,
  ) {
    final configFile = File(p.join(projectPath, 'dartstream.yaml'));
    final config =
        '''
# DartStream Project Configuration
name: $name
version: $version
type: $projectType
framework: $framework
middleware: $middleware
created_at: ${DateTime.now().toIso8601String()}

# Use 'dartstream configure' to set up:
# - Cloud vendor (GCP, AWS, Azure)
# - Authentication provider
# - Database
# - CI/CD tools
''';
    configFile.writeAsStringSync(config);
  }
}

