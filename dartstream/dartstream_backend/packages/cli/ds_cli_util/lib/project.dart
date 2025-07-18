import 'dart:io';
// import 'package:ds_tools_cli/ds_tools_cli.dart';

Directory getProjectDir(String projectName) {
  return Directory(projectName);
}

// Creating the basic project structure
void createProject(String projectName, {String? projectPath}) {
  print('Creating DartStream project: $projectName');

  final projectDir = getProjectDir(projectName);

  // Check if the directory already exists to avoid overwriting
  if (projectDir.existsSync()) {
    print(
      'A project named "$projectName" already exists in the current directory.',
    );
    return;
  }

  projectDir.createSync();

  // Example: Creating a lib directory
  Directory('${projectDir.path}/lib').createSync();

  // Example: Creating the main Dart file
  File('${projectDir.path}/lib/main.dart').writeAsStringSync('''
void main() {
  print('Hello, DartStream!');
}
''');

  // Creating a pubspec.yaml file
  File('${projectDir.path}/pubspec.yaml').writeAsStringSync('''
name: $projectName
description: A new DartStream project created by DS CLI.
version: 0.1.0

environment:
  sdk: ^3.8.1 # Adjust based on your compatibility

dependencies:
  # Add your project dependencies here, for example:
  http: ^0.13.3

dev_dependencies:
  test: ^1.25.5
''');
}
