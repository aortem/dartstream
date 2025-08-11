import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:ds_cli_util/ds_cli_utils.dart';
import 'package:path/path.dart' as p;

class DSConfigureCommand extends Command {
  @override
  final name = 'configure';
  @override
  final description =
      'Configure project with cloud provider, framework, and authentication.';

  // Vendor-Provider compatibility matrix
  static const Map<String, List<String>> vendorCompatibility = {
    'gcp': ['firebase', 'google_auth'],
    'aws': ['cognito', 'aws_auth'],
    'azure': ['entraid', 'azure_ad'],
    'local': [
      'firebase',
      'auth0',
      'magic',
      'stytch',
    ], // Local allows multiple options
  };

  DSConfigureCommand() {
    argParser
      ..addOption('name', abbr: 'n', defaultsTo: '', help: 'Project name.')
      ..addOption(
        'vendor',
        abbr: 'v',
        allowed: ['gcp', 'aws', 'azure', 'local'],
        help: 'Cloud vendor.',
      )
      ..addOption(
        'auth',
        abbr: 'a',
        allowed: ['firebase', 'cognito', 'entraid', 'auth0', 'magic', 'stytch'],
        help: 'Authentication provider.',
      )
      ..addOption(
        'database',
        abbr: 'd',
        allowed: ['firebase', 'mysql', 'postgres', 'none'],
        help: 'Database provider.',
      )
      ..addOption(
        'cicd',
        abbr: 'c',
        allowed: ['github', 'gitlab', 'custom', 'none'],
        help: 'CI/CD tool.',
      );
  }

  @override
  void run() {
    execute();
  }

  void execute({String Function()? readLineCallback}) {
    print('⚙️  Configuring Dartstream project...\n');

    var name = argResults?['name'];
    var vendor = argResults?['vendor'];
    var auth = argResults?['auth'];
    var database = argResults?['database'];
    var cicd = argResults?['cicd'];

    var read = readLineCallback ?? stdin.readLineSync;

    // Get project name
    if (name.isEmpty) {
      stdout.write('Enter project name: ');
      name = read() ?? '';
    }

    if (name.isEmpty) {
      print('❌ Project name cannot be empty.');
      return;
    }

    // Check if project exists
    final projectDir = getProjectDir(name);
    if (!projectDir.existsSync()) {
      print('❌ Project "$name" does not exist. Run "dartstream init" first.');
      return;
    }

    // Get cloud vendor
    if (vendor == null) {
      print('\nSelect cloud vendor:');
      print('1. Google Cloud Platform (GCP)');
      print('2. Amazon Web Services (AWS)');
      print('3. Microsoft Azure');
      print('4. Local Development');
      stdout.write('Choice (1-4): ');

      final choice = read() ?? '4';
      vendor = parseVendor(choice);
    }

    // Get authentication provider
    if (auth == null) {
      print('\nSelect authentication provider:');
      final compatibleProviders = getCompatibleAuthProviders(vendor);

      for (int i = 0; i < compatibleProviders.length; i++) {
        print('${i + 1}. ${formatProviderName(compatibleProviders[i])}');
      }
      stdout.write('Choice (1-${compatibleProviders.length}): ');

      final choice = int.tryParse(read() ?? '1') ?? 1;
      auth = compatibleProviders[choice - 1];
    }

    // Validate vendor-auth compatibility
    if (!isCompatible(vendor, auth)) {
      print('\n⚠️  Warning: $auth is not recommended for $vendor.');
      print(
        '   Recommended providers for $vendor: ${vendorCompatibility[vendor]?.join(', ')}',
      );
      stdout.write('   Continue anyway? (y/N): ');

      final confirm = read()?.toLowerCase() ?? 'n';
      if (confirm != 'y') {
        print('Configuration cancelled.');
        return;
      }
    }

    // Get database
    if (database == null) {
      print('\nSelect database:');
      final compatibleDatabases = getCompatibleDatabases(vendor);

      for (int i = 0; i < compatibleDatabases.length; i++) {
        print('${i + 1}. ${formatProviderName(compatibleDatabases[i])}');
      }
      stdout.write('Choice (1-${compatibleDatabases.length}): ');

      final choice = int.tryParse(read() ?? '1') ?? 1;
      database = compatibleDatabases[choice - 1];
    }

    // Get CI/CD tool
    if (cicd == null) {
      print('\nSelect CI/CD tool:');
      print('1. GitHub Actions');
      print('2. GitLab CI');
      print('3. Custom Script');
      print('4. None');
      stdout.write('Choice (1-4): ');

      final choice = read() ?? '4';
      cicd = parseCiCd(choice);
    }

    // Confirm configuration
    print('\n📋 Configuration Summary:');
    print('   Cloud Vendor: ${formatProviderName(vendor)}');
    print('   Authentication: ${formatProviderName(auth)}');
    print('   Database: ${formatProviderName(database)}');
    print('   CI/CD: ${formatProviderName(cicd)}');

    stdout.write('\nProceed with this configuration? (Y/n): ');
    final confirm = read()?.toLowerCase() ?? 'y';

    if (confirm != 'y') {
      print('Configuration cancelled.');
      return;
    }

    // Save configuration
    saveProjectConfig(
      name: name,
      content: {
        'vendor': vendor,
        'auth': auth,
        'database': database,
        'cicd': cicd,
        'configured': DateTime.now().toIso8601String(),
      },
    );

    // Generate CI/CD files
    if (cicd != 'none') {
      generateCICDFiles(projectName: name, ciCdChoice: cicd);
    }

    // Update pubspec.yaml with provider dependencies
    updatePubspecWithProviders(name, vendor, auth, database);

    // Initialize Standard Engine with providers
    initializeEngineProviders(name, vendor, auth, database);

    print('\n✅ Configuration complete!');
    print('   Run "dart pub get" to install dependencies.');
  }

  String parseVendor(String choice) {
    switch (choice) {
      case '1':
        return 'gcp';
      case '2':
        return 'aws';
      case '3':
        return 'azure';
      case '4':
      default:
        return 'local';
    }
  }

  String parseCiCd(String choice) {
    switch (choice) {
      case '1':
        return 'github';
      case '2':
        return 'gitlab';
      case '3':
        return 'custom';
      case '4':
      default:
        return 'none';
    }
  }

  String formatProviderName(String provider) {
    final formatted = provider
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');

    // Special cases
    switch (provider) {
      case 'gcp':
        return 'Google Cloud Platform';
      case 'aws':
        return 'Amazon Web Services';
      case 'entraid':
        return 'Microsoft EntraID';
      case 'auth0':
        return 'Auth0';
      case 'cognito':
        return 'AWS Cognito';
      case 'firebase':
        return 'Firebase';
      case 'mysql':
        return 'MySQL';
      case 'postgres':
        return 'PostgreSQL';
      default:
        return formatted;
    }
  }

  List<String> getCompatibleAuthProviders(String vendor) {
    if (vendor == 'local') {
      return ['firebase', 'auth0', 'magic', 'stytch', 'cognito', 'entraid'];
    }
    return vendorCompatibility[vendor] ?? ['firebase'];
  }

  List<String> getCompatibleDatabases(String vendor) {
    switch (vendor) {
      case 'gcp':
        return ['firebase', 'mysql', 'postgres', 'none'];
      case 'aws':
        return ['mysql', 'postgres', 'none'];
      case 'azure':
        return ['mysql', 'postgres', 'none'];
      case 'local':
      default:
        return ['firebase', 'mysql', 'postgres', 'none'];
    }
  }

  bool isCompatible(String vendor, String auth) {
    final compatible = vendorCompatibility[vendor] ?? [];
    return compatible.contains(auth) || vendor == 'local';
  }

  void updatePubspecWithProviders(
    String projectName,
    String vendor,
    String auth,
    String database,
  ) {
    print('📦 Updating dependencies...');

    final pubspecPath = p.join(getProjectDir(projectName).path, 'pubspec.yaml');
    final pubspecFile = File(pubspecPath);

    if (!pubspecFile.existsSync()) return;

    var content = pubspecFile.readAsStringSync();

    // Add provider dependencies
    final authPackage = getAuthPackageName(auth);
    final dbPackage = getDatabasePackageName(database);

    final dependencies = [
      if (authPackage.isNotEmpty) '  $authPackage: ^0.0.1',
      if (dbPackage.isNotEmpty) '  $dbPackage: ^0.0.1',
    ];

    if (dependencies.isNotEmpty) {
      // Insert after "dependencies:" line
      content = content.replaceFirst(
        'dependencies:',
        'dependencies:\n  # Provider packages\n${dependencies.join('\n')}',
      );

      pubspecFile.writeAsStringSync(content);
    }
  }

  String getAuthPackageName(String auth) {
    switch (auth) {
      case 'firebase':
        return 'ds_firebase_auth_provider';
      case 'cognito':
        return 'ds_cognito_auth_provider';
      case 'entraid':
        return 'ds_entraid_auth_provider';
      case 'auth0':
        return 'ds_auth0_auth_provider';
      case 'magic':
        return 'ds_magic_auth_provider';
      case 'stytch':
        return 'ds_stytch_auth_provider';
      default:
        return '';
    }
  }

  String getDatabasePackageName(String database) {
    switch (database) {
      case 'firebase':
        return 'ds_google_firebase_database';
      case 'mysql':
        return 'ds_google_mysql_database';
      case 'postgres':
        return 'ds_google_postgres_database';
      default:
        return '';
    }
  }

  void initializeEngineProviders(
    String projectName,
    String vendor,
    String auth,
    String database,
  ) {
    print('🔧 Generating provider configuration...');

    final providerConfigPath = p.join(
      getProjectDir(projectName).path,
      'lib',
      'src',
      'extensions',
      'providers.dart',
    );

    final providerFile = File(providerConfigPath);
    providerFile.createSync(recursive: true);

    providerFile.writeAsStringSync('''
// Auto-generated provider configuration
// Created by Dartstream CLI

import 'package:ds_standard_engine/ds_standard_engine.dart';
${auth != 'none' ? "import 'package:${getAuthPackageName(auth)}/${getAuthPackageName(auth)}.dart';" : ''}
${database != 'none' ? "import 'package:${getDatabasePackageName(database)}/${getDatabasePackageName(database)}.dart';" : ''}

Future<void> registerProviders(DSStandardCore core) async {
  // Register authentication provider
  ${getAuthRegistration(auth)}
  
  // Register database provider
  ${getDatabaseRegistration(database)}
  
  print('✅ Providers registered successfully');
}
''');
  }

  String getAuthRegistration(String auth) {
    switch (auth) {
      case 'firebase':
        return '''core.registerCoreExtension(
    extension: DSFirebaseAuthProvider(),
    baseFeature: 'authentication',
  );''';
      case 'cognito':
        return '''core.registerCoreExtension(
    extension: DSCognitoAuthProvider(),
    baseFeature: 'authentication',
  );''';
      case 'entraid':
        return '''core.registerCoreExtension(
    extension: DSEntraIDAuthProvider(),
    baseFeature: 'authentication',
  );''';
      default:
        return '// No authentication provider configured';
    }
  }

  String getDatabaseRegistration(String database) {
    switch (database) {
      case 'firebase':
        return '''core.registerCoreExtension(
    extension: DSFirebaseDatabase(),
    baseFeature: 'database',
  );''';
      case 'mysql':
        return '''core.registerCoreExtension(
    extension: DSMySQLDatabase(),
    baseFeature: 'database',
  );''';
      case 'postgres':
        return '''core.registerCoreExtension(
    extension: DSPostgresDatabase(),
    baseFeature: 'database',
  );''';
      default:
        return '// No database provider configured';
    }
  }
}
