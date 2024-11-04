import 'dart:io';

import 'package:ds_tools_cli/ds_tools_cli.dart';

//import 'package:args/command_runner.dart';

class DSAddMiddlewareCommand extends Command {
  @override
  final name = 'add_middleware';
  @override
  final description = 'Add middleware to the Flutter project';

  DSAddMiddlewareCommand() {
    argParser.addOption('type',
        abbr: 't',
        allowed: ['ds_shelf', 'ds_custom'],
        help: 'Type of middleware to add');
  }

  @override
  void run() {
    final type = argResults?['type'];

    if (type == null) {
      print(
          'Error: Middleware type is required. Use --type=ds_shelf or --type=ds_custom');
      return;
    }

    addMiddleware(type);
  }

  void addMiddleware(String type) {
    final flutterProjectDir = Directory.current.path;

    // Check if the 'lib' directory exists
    final libDir = Directory('$flutterProjectDir/lib');
    if (!libDir.existsSync()) {
      print('Error: lib directory not found in $flutterProjectDir/');
      return;
    }

    // Path to the main.dart file
    final mainDartFile = File('$flutterProjectDir/lib/main.dart');
    if (!mainDartFile.existsSync()) {
      print('Error: main.dart not found in $flutterProjectDir/lib/');
      return;
    }

    // Read the contents of main.dart
    final mainDartContent = mainDartFile.readAsStringSync();

    // Depending on the middleware type, add the necessary import and code
    String updatedContent;
    if (type == 'ds_shelf') {
      updatedContent = mainDartContent.replaceFirst('void main() {', '''
import 'package:ds_shelf/ds_shelf.dart';


void main() {
  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(_echoRequest);

  shelf_io.serve(handler, 'localhost', 8080);
}

shelf.Response _echoRequest(shelf.Request request) =>
  shelf.Response.ok('Request for "\${request.url}"');
''');
    } else if (type == 'ds_custom') {
      updatedContent = mainDartContent.replaceFirst('void main() {', '''
import 'package:ds_custom_middleware/ds_custom_middleware.dart';
import 'package:flutter/material.dart';

void main() {
  final customMiddleware = CustomMiddleware();
  customMiddleware.initialize();

  runApp(MyApp());
}
''');
    } else {
      // Handle unexpected type
      print('Unsupported middleware type: $type');
      return;
    }

    // Write the updated content back to main.dart
    mainDartFile.writeAsStringSync(updatedContent);
    print('Middleware $type has been added to main.dart');
  }
}

void main(List<String> arguments) {
  final runner = CommandRunner(
      'your_cli_tool', 'A CLI tool to add middleware to a Flutter project')
    ..addCommand(DSAddMiddlewareCommand());

  runner.run(arguments).catchError((error) {
    print(error);
  });
}
