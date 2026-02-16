import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';
import 'dart:convert';

class DSConfigureCommand extends Command {
  @override
  final name = 'configure';
  @override
  final description =
      'Configure cloud vendor, authentication, database, and CI/CD for your project.';

  DSConfigureCommand() {
    argParser
      ..addOption('name', abbr: 'n', help: 'Project name')
      ..addOption('vendor', help: 'Cloud vendor (gcp/aws/azure/local)')
      ..addOption('auth', help: 'Authentication provider')
      ..addOption('database', help: 'Database provider')
      ..addOption('cicd', help: 'CI/CD tool (github/gitlab/custom/none)')
      ..addFlag(
        'cloud-features',
        defaultsTo: false,
        help: 'Enable cloud-only features (for SAAS version)',
      )
      ..addFlag(
        'skip-examples',
        defaultsTo: false,
        help: 'Skip example code generation',
      );
  }

  // Compatibility mappings
  static const vendorCompatibility = {
    'gcp': ['firebase', 'google_auth', 'auth0', 'magic', 'stytch'],
    'aws': ['cognito', 'auth0', 'magic', 'stytch'],
    'azure': ['entraid', 'azure_ad', 'auth0'],
    'local': ['firebase', 'auth0', 'magic', 'stytch', 'cognito', 'entraid'],
  };

  static const vendorDatabases = {
    'gcp': ['firestore', 'postgres', 'mysql', 'mongodb', 'nosql'],
    'aws': ['dynamodb', 'rds', 'postgres', 'mysql', 'mongodb'],
    'azure': ['cosmos', 'sql', 'postgres', 'mysql'],
    'local': ['firestore', 'postgres', 'mysql', 'mongodb', 'nosql'],
  };

  @override
  void run() {
    execute();
  }

  void execute({String? Function()? readLineCallback}) {
    final read = readLineCallback ?? stdin.readLineSync;
    final name = argResults?['name'] ?? '';
    final isCloudEnabled = argResults?['cloud-features'] as bool;
    final skipExamples = argResults?['skip-examples'] as bool;

    print('⚙️  Configuring DartStream Project\n');

    // Load project config
    final projectConfig = _loadProjectConfig(name);
    if (projectConfig == null) {
      print('❌ No project found. Run "dartstream init" first.');
      return;
    }

    print('Project: ${projectConfig['name']}');
    print('Framework: ${projectConfig['framework']}');
    print('Middleware: ${projectConfig['middleware'] ?? 'dartstream'}');
    print('Version: ${projectConfig['version']}\n');

    // Determine if cloud features are available
    final canUseCloud = isCloudEnabled || projectConfig['version'] == 'beta';

    String vendor = argResults?['vendor'] ?? '';
    String auth = argResults?['auth'] ?? '';
    String database = argResults?['database'] ?? '';
    String cicd = argResults?['cicd'] ?? '';
    List<String> customTools = [];

    // Step 1: Cloud Vendor Selection (CLOUD ONLY)
    if (vendor.isEmpty) {
      if (canUseCloud) {
        print('Select your cloud vendor:');
        print('1. Google Cloud');
        print('2. AWS');
        print('3. Azure');
        print('4. Skip for now (for local development)');
        stdout.write('Choice (1-4): ');

        final choice = read() ?? '4';
        vendor = _mapVendorChoice(choice);
      } else {
        vendor = 'local';
        print(
          'Using local development configuration (cloud features disabled)\n',
        );
      }
    }

    // Step 2: Authentication SDK
    if (auth.isEmpty) {
      print('\nChoose an Authentication SDK:');
      final compatibleProviders = vendorCompatibility[vendor] ?? [];

      for (int i = 0; i < compatibleProviders.length; i++) {
        print('${i + 1}. ${_formatProviderName(compatibleProviders[i])}');
      }
      print(
        '${compatibleProviders.length + 1}. Skip for now (configure later)',
      );
      stdout.write('Choice (1-${compatibleProviders.length + 1}): ');

      final choice =
          int.tryParse(read() ?? '') ?? compatibleProviders.length + 1;
      auth = choice <= compatibleProviders.length
          ? compatibleProviders[choice - 1]
          : 'none';
    }

    // Validate compatibility
    if (!isCompatible(vendor, auth)) {
      print('\n⚠️  Warning: $auth may have limited support with $vendor.');
      stdout.write('Continue anyway? (y/N): ');
      final confirm = read()?.toLowerCase() ?? 'n';
      if (confirm != 'y') {
        print('Configuration cancelled.');
        return;
      }
    }

    // Step 3: Database Selection
    if (database.isEmpty) {
      print('\nChoose a database:');
      final compatibleDatabases = vendorDatabases[vendor] ?? [];

      for (int i = 0; i < compatibleDatabases.length; i++) {
        final dbName = compatibleDatabases[i];
        final suffix = (dbName == 'mongodb' || dbName == 'nosql')
            ? ' (extension created by partner)'
            : '';
        print('${i + 1}. ${_formatProviderName(dbName)}$suffix');
      }
      print('${compatibleDatabases.length + 1}. Skip for now');
      stdout.write('Choice (1-${compatibleDatabases.length + 1}): ');

      final choice =
          int.tryParse(read() ?? '') ?? compatibleDatabases.length + 1;
      database = choice <= compatibleDatabases.length
          ? compatibleDatabases[choice - 1]
          : 'none';
    }

    // Step 4: DevOps Integration (CLOUD ONLY)
    if (canUseCloud && vendor != 'local' && cicd.isEmpty) {
      print('\nWould you like to configure CI/CD and DevOps tools? (y/n)');
      final configureCicd = read()?.toLowerCase() ?? 'n';

      if (configureCicd == 'y') {
        print('\nSelect CI/CD tool:');
        print('1. GitHub Actions');
        print('2. GitLab CI');
        print('3. Custom Script');
        stdout.write('Choice (1-3): ');

        final choice = read() ?? '1';
        cicd = _mapCicdChoice(choice);
      } else {
        cicd = 'none';
      }
    } else if (cicd.isEmpty) {
      cicd = 'none';
    }

    // Step 5: Customize Tools (CLOUD ONLY)
    if (canUseCloud && vendor != 'local') {
      print(
        '\nCustomize your project with the following tools (select all that apply):',
      );
      print('1. Security Tools');
      print('2. Performance Tools');
      print('3. Integrations');
      print(
        'Enter choices separated by commas (e.g., 1,3) or press Enter to skip:',
      );

      final toolsChoice = read() ?? '';
      if (toolsChoice.isNotEmpty) {
        customTools = toolsChoice
            .split(',')
            .map((e) => _mapToolChoice(e.trim()))
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }

    // Step 6: Preview & Confirm Setup
    print('\n📋 Review your selections:');
    print('- Project Type: ${projectConfig['type'] ?? 'new'}');
    print('- Cloud Vendor: ${_formatProviderName(vendor)}');
    print('- Authentication SDK: ${_formatProviderName(auth)}');
    print('- Middleware: ${projectConfig['middleware'] ?? 'dartstream'}');
    print('- Framework: ${projectConfig['framework']}');
    print('- Database: ${_formatProviderName(database)}');
    if (cicd != 'none') {
      print('- CI/CD: ${_formatProviderName(cicd)}');
    }
    if (customTools.isNotEmpty) {
      print(
        '- Custom Tools: ${customTools.map((t) => _formatProviderName(t)).join(', ')}',
      );
    }

    print('\nConfirm setup? (y/n)');
    final confirm = read()?.toLowerCase() ?? 'n';

    if (confirm != 'y') {
      print('Configuration cancelled.');
      return;
    }

    // Save configuration
    saveProjectConfig(
      name: projectConfig['name'],
      content: {
        'vendor': vendor,
        'auth': auth,
        'database': database,
        'cicd': cicd,
        'customTools': customTools,
        'configuredAt': DateTime.now().toIso8601String(),
      },
    );

    // Generate CI/CD files
    if (cicd != 'none') {
      generateCICDFiles(projectName: projectConfig['name'], ciCdChoice: cicd);
    }

    // Update pubspec with dependencies
    updatePubspecWithProviders(projectConfig['name'], vendor, auth, database);

    // Step 7: Generate Code with Examples & Documentation (Optional)
    if (!skipExamples) {
      print(
        '\nWould you like to include example code and inline documentation? (y/n)',
      );
      final generateExamples = read()?.toLowerCase() ?? 'y';

      if (generateExamples == 'y') {
        _generateExampleCode(
          projectConfig['name'],
          vendor,
          auth,
          database,
          projectConfig['framework'],
        );
      }
    }

    print('\n✅ Configuration complete!');
    print('\nNext steps:');
    print('1. dart pub get    # Install dependencies');
    print('2. dart run        # Start your server');
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

  Map<String, dynamic>? _loadProjectConfig(String projectName) {
    // Find the dartstream backend root for reliable resolution
    final dartstreamRoot = _findDartstreamRoot();

    // Try multiple locations
    final paths = [
      'dartstream.yaml',
      p.join(projectName, 'dartstream.yaml'),
      p.join('projects', projectName, 'dartstream.yaml'),
      p.join('..', 'projects', projectName, 'dartstream.yaml'),
      // Root-relative path (works regardless of cwd depth)
      p.join(dartstreamRoot, 'projects', projectName, 'dartstream.yaml'),
    ];

    for (final path in paths) {
      final file = File(path);
      if (file.existsSync()) {
        final content = file.readAsStringSync();
        return Map<String, dynamic>.from(loadYaml(content));
      }
    }

    return null;
  }

  Directory getProjectDir(String projectName) {
    // Find the dartstream backend root for reliable resolution
    final dartstreamRoot = _findDartstreamRoot();

    // Try multiple locations
    final paths = [
      p.join('projects', projectName),
      p.join('..', 'projects', projectName),
      p.join('..', '..', 'projects', projectName),
      p.join('..', '..', '..', 'projects', projectName),
      // Root-relative path (works regardless of cwd depth)
      p.join(dartstreamRoot, 'projects', projectName),
    ];

    for (final path in paths) {
      final dir = Directory(path);
      if (dir.existsSync()) {
        return dir;
      }
    }

    // Default to projects folder from dartstream root
    return Directory(p.join(dartstreamRoot, 'projects', projectName));
  }

  void saveProjectConfig({
    required String name,
    required Map<String, dynamic> content,
  }) {
    final projectPath = getProjectDir(name).path;
    final configFile = File(p.join(projectPath, 'config.yaml'));
    configFile.createSync(recursive: true);

    // Convert to YAML-like format
    final lines = <String>[];
    content.forEach((key, value) {
      if (value is List) {
        lines.add('$key:');
        for (final item in value) {
          lines.add('  - $item');
        }
      } else {
        lines.add('$key: $value');
      }
    });

    configFile.writeAsStringSync(lines.join('\n'));
  }

  void updatePubspecWithProviders(
    String projectName,
    String vendor,
    String auth,
    String database,
  ) {
    print('📦 Updating dependencies...');

    final projectPath = getProjectDir(projectName).path;
    final pubspecFile = File(p.join(projectPath, 'pubspec.yaml'));

    if (!pubspecFile.existsSync()) return;

    var content = pubspecFile.readAsStringSync();

    // Add provider dependencies
    final dependencies = <String>[];
    if (auth != 'none') {
      dependencies.add('  ${_getAuthPackageName(auth)}: ^0.0.1');
    }
    if (database != 'none') {
      dependencies.add('  ${_getDatabasePackageName(database)}: ^0.0.1');
    }

    if (dependencies.isNotEmpty) {
      // Insert after dependencies: line
      content = content.replaceFirst(
        'dependencies:',
        'dependencies:\n  # Provider packages\n${dependencies.join('\n')}',
      );

      pubspecFile.writeAsStringSync(content);
    }
  }

  void generateCICDFiles({
    required String projectName,
    required String ciCdChoice,
  }) {
    final projectPath = getProjectDir(projectName).path;

    if (ciCdChoice == 'github') {
      final dir = Directory(p.join(projectPath, '.github', 'workflows'));
      dir.createSync(recursive: true);

      File(p.join(dir.path, 'dartstream.yml')).writeAsStringSync('''
name: DartStream CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    - uses: dart-lang/setup-dart@v1
      with:
        sdk: 3.10.9
    - run: dart pub get
    - run: dart test
    - run: dart analyze
''');
    } else if (ciCdChoice == 'gitlab') {
      File(p.join(projectPath, '.gitlab-ci.yml')).writeAsStringSync('''
image: dart:3.10.9

stages:
  - test
  - build

before_script:
  - dart pub get

test:
  stage: test
  script:
    - dart test
    - dart analyze

build:
  stage: build
  script:
    - dart compile exe bin/main.dart
''');
    }

    print('✅ Generated CI/CD configuration for $ciCdChoice');
  }

  void _generateExampleCode(
    String projectName,
    String vendor,
    String auth,
    String database,
    String framework,
  ) {
    final projectPath = getProjectDir(projectName).path;

    // Generate auth example
    if (auth != 'none') {
      final authExample = _generateAuthExample(auth);
      File(p.join(projectPath, 'lib', 'services', 'auth_service.dart'))
        ..createSync(recursive: true)
        ..writeAsStringSync(authExample);
    }

    // Generate database example
    if (database != 'none') {
      final dbExample = _generateDatabaseExample(database);
      File(p.join(projectPath, 'lib', 'services', 'database_service.dart'))
        ..createSync(recursive: true)
        ..writeAsStringSync(dbExample);
    }

    print('📝 Generated example code in lib/services/');
  }

  String _generateAuthExample(String auth) {
    final providerClass = _getAuthProviderClass(auth);
    final packageName = _getAuthPackageName(auth);

    return '''
import 'package:ds_standard_features/auth.dart';
import 'package:$packageName/$packageName.dart';

/// Example authentication service using $auth
class AuthService {
  final authProvider = $providerClass();
  
  Future<void> initialize() async {
    await authProvider.initialize();
    print('✅ Authentication initialized');
  }
  
  Future<User?> signIn(String email, String password) async {
    try {
      return await authProvider.signIn(email, password);
    } catch (e) {
      print('Error signing in: \$e');
      return null;
    }
  }
  
  Future<void> signOut() async {
    await authProvider.signOut();
  }
  
  Stream<User?> get authStateChanges => authProvider.authStateChanges;
}
''';
  }

  String _generateDatabaseExample(String database) {
    final providerClass = _getDatabaseProviderClass(database);
    final packageName = _getDatabasePackageName(database);

    return '''
import 'package:ds_standard_features/database.dart';
import 'package:$packageName/$packageName.dart';

/// Example database service using $database
class DatabaseService {
  final dbProvider = $providerClass();
  
  Future<void> initialize() async {
    await dbProvider.connect();
    print('✅ Database connected');
  }
  
  Future<void> create(String collection, Map<String, dynamic> data) async {
    await dbProvider.insert(collection, data);
  }
  
  Future<List<Map<String, dynamic>>> read(String collection) async {
    return await dbProvider.query(collection);
  }
  
  Future<void> update(String collection, String id, Map<String, dynamic> data) async {
    await dbProvider.update(collection, id, data);
  }
  
  Future<void> delete(String collection, String id) async {
    await dbProvider.delete(collection, id);
  }
}
''';
  }

  String _mapVendorChoice(String choice) {
    switch (choice) {
      case '1':
        return 'gcp';
      case '2':
        return 'aws';
      case '3':
        return 'azure';
      default:
        return 'local';
    }
  }

  String _mapCicdChoice(String choice) {
    switch (choice) {
      case '1':
        return 'github';
      case '2':
        return 'gitlab';
      case '3':
        return 'custom';
      default:
        return 'none';
    }
  }

  String _mapToolChoice(String choice) {
    switch (choice) {
      case '1':
        return 'security';
      case '2':
        return 'performance';
      case '3':
        return 'integrations';
      default:
        return '';
    }
  }

  String _formatProviderName(String provider) {
    final formatted = {
      'gcp': 'Google Cloud Platform',
      'aws': 'Amazon Web Services',
      'azure': 'Microsoft Azure',
      'local': 'Local Development',
      'firebase': 'Firebase Authentication',
      'cognito': 'AWS Cognito',
      'entraid': 'Azure Active Directory',
      'azure_ad': 'Azure Active Directory',
      'auth0': 'Auth0',
      'magic': 'Magic',
      'stytch': 'Stytch',
      'firestore': 'Firebase Firestore',
      'postgres': 'PostgreSQL',
      'mysql': 'MySQL',
      'mongodb': 'MongoDB',
      'nosql': 'NoSQL Database',
      'dynamodb': 'DynamoDB',
      'rds': 'AWS RDS',
      'cosmos': 'Azure Cosmos DB',
      'sql': 'Azure SQL',
      'github': 'GitHub Actions',
      'gitlab': 'GitLab CI',
      'custom': 'Custom Script',
      'security': 'Security Tools',
      'performance': 'Performance Tools',
      'integrations': 'Integrations',
      'none': 'Not configured',
    };

    return formatted[provider] ?? provider;
  }

  String _getAuthProviderClass(String auth) {
    switch (auth) {
      case 'firebase':
        return 'DSFirebaseAuthProvider';
      case 'cognito':
        return 'DSCognitoAuthProvider';
      case 'entraid':
        return 'DSEntraIDAuthProvider';
      case 'auth0':
        return 'DSAuth0Provider';
      case 'magic':
        return 'DSMagicProvider';
      case 'stytch':
        return 'DSStytchProvider';
      default:
        return 'DSAuthProvider';
    }
  }

  String _getDatabaseProviderClass(String database) {
    switch (database) {
      case 'firestore':
        return 'DSFirestoreProvider';
      case 'postgres':
        return 'DSPostgreSQLProvider';
      case 'mysql':
        return 'DSMySQLProvider';
      case 'mongodb':
        return 'DSMongoDBProvider';
      case 'dynamodb':
        return 'DSDynamoDBProvider';
      case 'cosmos':
        return 'DSCosmosDBProvider';
      default:
        return 'DSDatabaseProvider';
    }
  }

  String _getAuthPackageName(String auth) {
    return 'ds_${auth}_auth';
  }

  String _getDatabasePackageName(String database) {
    return 'ds_${database}_db';
  }

  bool isCompatible(String vendor, String auth) {
    if (auth == 'none') return true;
    final compatible = vendorCompatibility[vendor] ?? [];
    return compatible.contains(auth);
  }
}
