import 'dart:io';
import 'package:ds_tools_cli/ds_tools_cli.dart';

class DSInit {
  void run() {
    print("Running core functionality...");
  }

  String performAction() {
    return "Expected Result"; //For testing Only
  }
}

class DSInitCommand extends Command {
  @override
  final name = "init";
  @override
  final description = "Initializes a new DartStream project.";

  DSInitCommand() {
    // Define any specific arguments required for initializing a project
    // For example, allowing users to specify a project name
    argParser.addOption('name', abbr: 'n', help: 'The name of the project.');
  }

  @override
  void run() {
    final projectName = argResults?['name'] ?? 'default_project_name';
    final projectDir = Directory(projectName);

    // Check if the directory already exists to avoid overwriting
    if (projectDir.existsSync()) {
      print(
          'A project named "$projectName" already exists in the current directory.');
      return;
    }

    // Creating the basic project structure
    print('Creating DartStream project: $projectName');
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

    print('Project $projectName has been successfully created!');
  }
}
