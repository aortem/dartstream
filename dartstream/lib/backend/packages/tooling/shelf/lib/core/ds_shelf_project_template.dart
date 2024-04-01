// File: shelf/shelf_project_template.dart

import 'dart:io';

class ShelfProjectTemplate {
  static void createShelfProject(String projectName) {
    final projectDir = Directory('path/to/your/projects/$projectName');
    if (!projectDir.existsSync()) {
      projectDir.createSync(recursive: true);
      // Additional logic to create pubspec.yaml, lib folder, etc.
      print('Shelf project created: $projectName');
    } else {
      print('Project $projectName already exists.');
    }
  }

  // Other utility methods for scaffolding (e.g., creating pubspec.yaml, main.dart)
}
