import 'dart:io';
import 'package:ds_cli_util/ds_cli_utils.dart';
import 'package:path/path.dart' as p;

/// Walks up the directory tree to find the dartstream backend root.
/// The root is identified as the directory that contains a 'packages/' folder.
/// This is cross-platform (works on both Linux and Windows).
String _findDartstreamRoot() {
  var currentDir = Directory.current;
  while (!Directory(p.join(currentDir.path, 'packages')).existsSync()) {
    final parent = currentDir.parent;
    if (parent.path == currentDir.path) {
      // Reached filesystem root, fall back to 4 levels up from cwd
      return p.normalize(
        p.join(Directory.current.path, '..', '..', '..', '..'),
      );
    }
    currentDir = parent;
  }
  return currentDir.path;
}

Directory getProjectDir(String projectName) {
  // Find dartstream root using cross-platform directory traversal
  final dartstreamRoot = _findDartstreamRoot();

  return Directory(p.join(dartstreamRoot, 'projects', projectName));
}

// Enhanced project creation with templates
void createProject({
  required String name,
  required String version,
  String? framework,
}) {
  print('ðŸ“¦ Creating Dartstream project: $name');

  final projectDir = getProjectDir(name);

  // Check if directory exists
  if (projectDir.existsSync()) {
    print('âŒ Project "$name" already exists.');
    return;
  }

  projectDir.createSync();

  // Create standard project structure
  _createProjectStructure(projectDir.path);

  // Generate framework-specific files
  if (framework != null) {
    _generateFrameworkFiles(projectDir.path, framework, name, version);
  } else {
    _generateBasicFiles(projectDir.path, name, version);
  }

  // Save initial configuration
  saveProjectConfig(
    name: name,
    content: {
      'name': name,
      'version': version,
      'framework': framework ?? 'dart_web',
      'created': DateTime.now().toIso8601String(),
    },
  );

  print('âœ… Project created successfully!');
}

void _createProjectStructure(String projectPath) {
  // Core directories
  Directory('$projectPath/lib').createSync();
  Directory('$projectPath/lib/src').createSync();
  Directory('$projectPath/lib/src/core').createSync();
  Directory('$projectPath/lib/src/extensions').createSync();
  Directory('$projectPath/lib/src/middleware').createSync();
  Directory('$projectPath/test').createSync();
  Directory('$projectPath/config').createSync();
  Directory('$projectPath/bin').createSync();

  // Web directories if needed
  Directory('$projectPath/web').createSync();
  Directory('$projectPath/web/assets').createSync();
}

void _generateBasicFiles(String projectPath, String name, String version) {
  // Basic main.dart
  File('$projectPath/lib/main.dart').writeAsStringSync('''
void main() {
  print('Welcome to Dartstream!');
  print('Project: $name');
  print('Version: $version');
}
''');

  // Basic pubspec.yaml
  _generatePubspec(projectPath, name, version, 'dart_web');

  // Basic README
  _generateReadme(projectPath, name, 'Dart');
}

void _generateFrameworkFiles(
  String projectPath,
  String framework,
  String name,
  String version,
) {
  switch (framework) {
    case 'flutter_web':
      _generateFlutterWebTemplate(projectPath, name, version);
      break;
    case 'flutter_mobile':
      _generateFlutterMobileTemplate(projectPath, name, version);
      break;
    case 'dart_web':
      _generateDartWebTemplate(projectPath, name, version);
      break;
    case 'vue':
      _generateVueTemplate(projectPath, name, version);
      break;
    case 'svelte':
      _generateSvelteTemplate(projectPath, name, version);
      break;
    default:
      _generateBasicFiles(projectPath, name, version);
  }
}

void _generateFlutterWebTemplate(
  String projectPath,
  String name,
  String version,
) {
  // Flutter Web main.dart
  File('$projectPath/lib/main.dart').writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:ds_standard_engine/ds_standard_engine.dart';

void main() async {
  final core = DSStandardCore(
    projectConfig: {
      'name': '$name',
      'version': '$version',
      'framework': 'flutter_web',
    },
  );
  
  await core.initialize();
  runApp(MyApp(core: core));
}

class MyApp extends StatelessWidget {
  final DSStandardCore core;
  
  const MyApp({Key? key, required this.core}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$name',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$name')),
      body: Center(
        child: Text(
          'Welcome to Dartstream Flutter Web!',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
''');

  // Flutter Web index.html
  File('$projectPath/web/index.html').writeAsStringSync('''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$name</title>
  <link rel="manifest" href="manifest.json">
</head>
<body>
  <script src="main.dart.js"></script>
</body>
</html>
''');

  _generatePubspec(projectPath, name, version, 'flutter_web');
  _generateReadme(projectPath, name, 'Flutter Web');
}

void _generateFlutterMobileTemplate(
  String projectPath,
  String name,
  String version,
) {
  // Flutter Mobile main.dart
  File('$projectPath/lib/main.dart').writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:ds_standard_engine/ds_standard_engine.dart';
import 'package:ds_flutter_mobile/ds_flutter_mobile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final core = DSStandardCore(
    projectConfig: {
      'name': '$name',
      'version': '$version',
      'framework': 'flutter_mobile',
    },
  );
  
  await core.initialize();
  
  // Register mobile-specific extensions
  core.registerCoreExtension(
    extension: DSFlutterMobileCore(),
    baseFeature: 'mobile',
  );
  
  runApp(MyApp(core: core));
}

class MyApp extends StatelessWidget {
  final DSStandardCore core;
  
  const MyApp({Key? key, required this.core}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$name',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$name')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Dartstream Flutter Mobile',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add navigation or functionality
              },
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
''');

  _generatePubspec(projectPath, name, version, 'flutter_mobile');
  _generateReadme(projectPath, name, 'Flutter Mobile');
}

void _generateDartWebTemplate(String projectPath, String name, String version) {
  // Dart Web server with Shelf
  File('$projectPath/bin/server.dart').writeAsStringSync('''
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:ds_standard_engine/ds_standard_engine.dart';

void main() async {
  final core = DSStandardCore(
    projectConfig: {
      'name': '$name',
      'version': '$version',
      'framework': 'dart_web',
    },
  );
  
  await core.initialize();
  
  final router = Router()
    ..get('/', _rootHandler)
    ..get('/api/health', _healthHandler);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, 'localhost', port);
  
  print('ðŸš€ Server running on http://\${server.address.host}:\${server.port}');
}

Response _rootHandler(Request req) {
  return Response.ok('Welcome to $name - Powered by Dartstream!');
}

Response _healthHandler(Request req) {
  return Response.ok('{"status": "healthy", "framework": "dartstream"}',
    headers: {'content-type': 'application/json'});
}
''');

  _generatePubspec(projectPath, name, version, 'dart_web');
  _generateReadme(projectPath, name, 'Dart Web');
}

void _generateVueTemplate(String projectPath, String name, String version) {
  // Vue.js integration with Dart backend
  File('$projectPath/bin/server.dart').writeAsStringSync('''
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_router/shelf_router.dart';

void main() async {
  final router = Router()
    ..mount('/api/', _apiRouter())
    ..get('/<ignored|.*>', createStaticHandler('web'));

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, 'localhost', port);
  
  print('ðŸš€ Server with Vue.js running on http://\${server.address.host}:\${server.port}');
}

Router _apiRouter() {
  final api = Router();
  api.get('/health', (Request req) => Response.ok('{"status": "ok"}'));
  return api;
}
''');

  // Vue index.html
  File('$projectPath/web/index.html').writeAsStringSync('''
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$name - Vue + Dartstream</title>
  <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
</head>
<body>
  <div id="app">
    <h1>{{ title }}</h1>
    <p>{{ message }}</p>
  </div>
  
  <script>
    const { createApp } = Vue;
    
    createApp({
      data() {
        return {
          title: '$name',
          message: 'Powered by Vue.js and Dartstream!'
        }
      }
    }).mount('#app');
  </script>
</body>
</html>
''');

  _generatePubspec(projectPath, name, version, 'vue');
  _generateReadme(projectPath, name, 'Vue.js');
}

void _generateSvelteTemplate(String projectPath, String name, String version) {
  // Similar to Vue but for Svelte
  File('$projectPath/bin/server.dart').writeAsStringSync('''
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_router/shelf_router.dart';

void main() async {
  final router = Router()
    ..mount('/api/', _apiRouter())
    ..get('/<ignored|.*>', createStaticHandler('public'));

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, 'localhost', port);
  
  print('ðŸš€ Server with Svelte running on http://\${server.address.host}:\${server.port}');
}

Router _apiRouter() {
  final api = Router();
  api.get('/health', (Request req) => Response.ok('{"status": "ok"}'));
  return api;
}
''');

  _generatePubspec(projectPath, name, version, 'svelte');
  _generateReadme(projectPath, name, 'Svelte');
}

void _generatePubspec(
  String projectPath,
  String name,
  String version,
  String framework,
) {
  final isPreRelease = version == 'beta';
  final versionSuffix = isPreRelease ? '-pre' : '';

  String dependencies = '''
  # Core Dartstream packages
  ds_standard_engine: ^0.0.1
  ds_standard_features: ^0.1.6
  
  # Utilities
  path: ^1.9.0
  yaml: ^3.1.0''';

  // Add framework-specific dependencies
  switch (framework) {
    case 'flutter_web':
    case 'flutter_mobile':
      dependencies += '''
  
  # Flutter dependencies
  flutter:
    sdk: flutter
  ds_flutter_mobile: ^0.0.1$versionSuffix''';
      break;

    case 'dart_web':
    case 'vue':
    case 'svelte':
      dependencies += '''
  
  # Web server dependencies
  shelf: ^1.4.0
  shelf_router: ^1.1.0
  shelf_static: ^1.1.0
  ds_shelf: ^0.0.1$versionSuffix''';
      break;
  }

  File('$projectPath/pubspec.yaml').writeAsStringSync('''
name: $name
description: A Dartstream project using $framework.
version: 0.0.1
publish_to: none

environment:
  sdk: ^3.12.2

dependencies:
$dependencies

dev_dependencies:
  test: ^1.25.0
  lints: ^4.0.0
''');
}

void _generateReadme(String projectPath, String name, String framework) {
  File('$projectPath/README.md').writeAsStringSync('''
# $name

A Dartstream project built with $framework.

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
   ${framework.contains('Flutter') ? 'flutter run' : 'dart run bin/server.dart'}
   ```

## Framework

This project uses **$framework** with Dartstream Standard Engine.

## Documentation

Visit [dartstream.io/docs](https://dartstream.io/docs) for complete documentation.

## License

See LICENSE file for details.
''');
}
