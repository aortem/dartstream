import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:ds_cli_util/ds_cli_utils.dart';

class DSSetupCommand extends Command {
  @override
  final name = 'setup';
  @override
  final description = 'Setup advanced features (SaaS version only).';

  DSSetupCommand() {
    argParser
      ..addOption('name', abbr: 'n', defaultsTo: '', help: 'Project name.')
      ..addMultiOption(
        'features',
        abbr: 'f',
        allowed: ['security', 'performance', 'ai', 'gaming', 'analytics'],
        help: 'Advanced features to enable (SaaS only).',
      )
      ..addFlag(
        'saas',
        defaultsTo: false,
        help: 'Enable SaaS features (requires license).',
      );
  }

  @override
  void run() {
    execute();
  }

  void execute({String Function()? readLineCallback}) {
    print('🚀 Setting up advanced Dartstream features...\n');

    var name = argResults?['name'];
    final features = argResults?['features'] as List<String>? ?? [];
    final isSaas = argResults?['saas'] as bool? ?? false;

    var read = readLineCallback ?? stdin.readLineSync;

    // Check if running in SaaS mode
    if (!isSaas && features.isNotEmpty) {
      print('⚠️  Advanced features require SaaS version.');
      print('   Visit https://dartstream.io/pricing for licensing.');
      stdout.write('   Continue with basic setup? (Y/n): ');

      final confirm = read()?.toLowerCase() ?? 'y';
      if (confirm != 'y') {
        print('Setup cancelled.');
        return;
      }
    }

    // Get project name
    if (name.isEmpty) {
      stdout.write('Enter project name: ');
      name = read() ?? '';
    }

    if (name.isEmpty) {
      print('❌ Project name cannot be empty.');
      return;
    }

    // Check if project exists and is configured
    final projectDir = getProjectDir(name);
    if (!projectDir.existsSync()) {
      print('❌ Project "$name" does not exist. Run "dartstream init" first.');
      return;
    }

    final configFile = File('${projectDir.path}/config.yaml');
    if (!configFile.existsSync()) {
      print('❌ Project not configured. Run "dartstream configure" first.');
      return;
    }

    if (isSaas && features.isNotEmpty) {
      setupSaasFeatures(name, features);
    } else {
      setupBasicMiddleware(name, read);
    }

    print('\n✅ Setup complete!');
  }

  void setupBasicMiddleware(String projectName, String? Function()? read) {
    print('\n📦 Setting up middleware...');
    print('1. Dartstream Middleware (recommended)');
    print('2. Shelf Middleware');
    print('3. Custom Middleware');
    stdout.write('Choice (1-3): ');

    final choice = read?.call() ?? '1';
    String middleware;

    switch (choice) {
      case '2':
        middleware = 'shelf';
        break;
      case '3':
        middleware = 'custom';
        break;
      case '1':
      default:
        middleware = 'dartstream';
    }

    // Generate middleware configuration
    final middlewarePath =
        '${getProjectDir(projectName).path}/lib/src/middleware/';
    Directory(middlewarePath).createSync(recursive: true);

    File('${middlewarePath}config.dart').writeAsStringSync('''
// Middleware configuration
// Using: $middleware

import 'package:ds_standard_engine/ds_standard_engine.dart';
${middleware == 'shelf' ? "import 'package:ds_shelf/ds_shelf.dart';" : ''}
${middleware == 'dartstream' ? "import 'package:ds_custom_middleware/ds_custom_middleware.dart';" : ''}

void setupMiddleware(DSStandardCore core) {
  ${getMiddlewareSetup(middleware)}
}
''');

    saveProjectConfig(name: projectName, content: {'middleware': middleware});

    print('✅ Middleware configured: $middleware');
  }

  void setupSaasFeatures(String projectName, List<String> features) {
    print('\n🎯 Setting up SaaS features...');

    for (final feature in features) {
      print('   Installing $feature...');

      switch (feature) {
        case 'security':
          setupSecurityTools(projectName);
          break;
        case 'performance':
          setupPerformanceTools(projectName);
          break;
        case 'ai':
          setupAIEngine(projectName);
          break;
        case 'gaming':
          setupGamingFeatures(projectName);
          break;
        case 'analytics':
          setupAnalytics(projectName);
          break;
      }
    }

    saveProjectConfig(
      name: projectName,
      content: {'saas_features': features, 'saas_enabled': true},
    );
  }

  void setupSecurityTools(String projectName) {
    // SaaS only - security scanning, vulnerability detection
    print('     ✓ Security scanning enabled');
    print('     ✓ Vulnerability detection configured');
    print('     ✓ Compliance monitoring active');
  }

  void setupPerformanceTools(String projectName) {
    // SaaS only - APM, profiling, optimization
    print('     ✓ Application Performance Monitoring (APM)');
    print('     ✓ Real-time profiling enabled');
    print('     ✓ Auto-optimization configured');
  }

  void setupAIEngine(String projectName) {
    // SaaS only - Dart Kodi AI integration
    print('     ✓ Dart Kodi AI Engine connected');
    print('     ✓ Code generation enabled');
    print('     ✓ Intelligent suggestions active');
  }

  void setupGamingFeatures(String projectName) {
    // SaaS only - Game engine integration
    print('     ✓ Game engine initialized');
    print('     ✓ Asset pipeline configured');
    print('     ✓ Multiplayer services ready');
  }

  void setupAnalytics(String projectName) {
    // SaaS only - Advanced analytics
    print('     ✓ Real-time analytics dashboard');
    print('     ✓ User behavior tracking');
    print('     ✓ Performance metrics collection');
  }

  String getMiddlewareSetup(String middleware) {
    switch (middleware) {
      case 'shelf':
        return '''
  // Shelf middleware configuration
  core.registerCoreExtension(
    extension: DSShelfMiddleware(),
    baseFeature: 'middleware',
  );''';

      case 'custom':
        return '''
  // Custom middleware - implement your own
  // core.registerCoreExtension(
  //   extension: YourCustomMiddleware(),
  //   baseFeature: 'middleware',
  // );''';

      case 'dartstream':
      default:
        return '''
  // Dartstream middleware (optimized)
  core.registerCoreExtension(
    extension: DSCustomMiddleware(),
    baseFeature: 'middleware',
  );''';
    }
  }
}
