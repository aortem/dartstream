import 'dart:io';
import '../project.dart';
import './examples.dart';

void generateCICDFiles({
  required String projectName,
  required String ciCdChoice,
}) {
  final projectDir = getProjectDir(projectName);

  if (!projectDir.existsSync()) {
    print('❌ Project "$projectName" does not exist.');
    return;
  }

  String exampleCiCdContent = '';
  String destinationPath = '';

  switch (ciCdChoice) {
    case '1':
    case 'github':
      exampleCiCdContent = githubExample;
      destinationPath = '.github/workflows/main.yml';
      break;

    case '2':
    case 'gitlab':
      exampleCiCdContent = gitlabExample;
      destinationPath = '.gitlab-ci.yml';
      break;

    case '3':
    case 'custom':
      exampleCiCdContent = _generateCustomScript();
      destinationPath = 'ci/build.sh';
      break;

    default:
      print('⚠️  Unknown CI/CD choice: $ciCdChoice');
      return;
  }

  final fullDestinationPath = '${projectDir.path}/$destinationPath';
  final file = File(fullDestinationPath);

  // Create directories if needed
  file.createSync(recursive: true);
  file.writeAsStringSync(exampleCiCdContent);

  // Make shell scripts executable
  if (destinationPath.endsWith('.sh')) {
    Process.runSync('chmod', ['+x', fullDestinationPath]);
  }

  print('✅ CI/CD configuration created: $destinationPath');
}

String _generateCustomScript() {
  return '''#!/bin/bash
# Custom Dartstream Build Script

set -e

echo "🚀 Building Dartstream project..."

# Install dependencies
echo "📦 Installing dependencies..."
dart pub get

# Run analysis
echo "🔍 Running static analysis..."
dart analyze

# Run tests
echo "🧪 Running tests..."
dart test

# Build project
echo "🔨 Building project..."
dart compile exe bin/server.dart -o build/server

echo "✅ Build complete!"
''';
}
