// ds_commands/ds_setup_command.dart
import 'package:args/command_runner.dart';
import 'dart:io';
import 'package:ds_cli_util/ds_cli_utils.dart';

class DSSetupCommand extends Command {
  @override
  final name = 'setup';
  @override
  final description = 'Set up middleware, CI/CD, and additional tools.';

  DSSetupCommand() {
    argParser.addOption(
      'name',
      abbr: 'n',
      defaultsTo: '',
      help: 'Specify the project name.',
    );
    argParser.addOption(
      'middleware',
      abbr: 'm',
      defaultsTo: '',
      help: 'Specify the middleware (1. Dartstream, 2. Shelf, 3. Custom).',
    );
    argParser.addOption(
      'cicd',
      abbr: 'c',
      defaultsTo: '',
      help: 'Specify the CI/CD tool.',
    );
    argParser.addOption(
      'tools',
      abbr: 't',
      defaultsTo: '',
      help: 'Specify the tools (1. Security, 2. Performance, 3. Integrations).',
    );
  }

  @override
  void run() {
    this.execute();
  }

  void execute({String Function()? readLineCallback}) {
    var name = argResults?['name'];
    var ciCdChoice = argResults?['cicd'];
    var middlewareChoice = argResults?['middleware'];
    var toolsChoice = argResults?['tools'];

    var read = readLineCallback ?? stdin.readLineSync;

    print('Setting up project components...');

    if (name.isEmpty) {
      stdout.write('Enter project name: ');
      name = read();
    }

    if (name.isEmpty) {
      print('Project name cannot be empty.');
      return;
    }

    final projectDir = getProjectDir(name);

    // Check if the directory already exists
    if (!projectDir.existsSync()) {
      print('Project "$name" does not exist. Please initialize it first.');
      return;
    }

    // Middleware Selection
    if (middlewareChoice.isEmpty) {
      stdout.write('Choose middleware (1. Dartstream, 2. Shelf, 3. Custom): ');
      middlewareChoice = read();
    }

    var middleware = _parseMiddleware(middlewareChoice);

    // CI/CD Tool Selection
    if (ciCdChoice.isEmpty) {
      stdout.write(
        'Choose CI/CD tool (1. GitHub Actions, 2. GitLab CI, 3. Custom Script): ',
      );
      ciCdChoice = read();
    }

    var ciCdTool = _parseCiCdTool(ciCdChoice);

    if (toolsChoice.isEmpty) {
      // Custom Tools Selection
      stdout.write(
        'Select tools (1. Security, 2. Performance, 3. Integrations): ',
      );
      toolsChoice = read();
    }

    var tools = toolsChoice?.split(',').map(_parseTool).toList();

    print("Middleware: $middleware");
    print("CI/CD: $ciCdTool");
    print("Tools: ${tools?.join(', ')}");

    generateCICDFiles(projectName: name, ciCdChoice: ciCdChoice);

    saveProjectConfig(
      name: name,
      content: {
        'ciCdChoice': ciCdChoice,
        'middlewareChoice': middlewareChoice,
        'toolsChoice': toolsChoice,
      },
    );

    print("Project setup completed successfully!");
  }

  String _parseMiddleware(String? choice) {
    switch (choice) {
      case '1':
        return 'Dartstream Middleware';
      case '2':
        return 'Shelf Middleware';
      case '3':
        return 'Custom Middleware';
      default:
        return '';
    }
  }

  String _parseCiCdTool(String? choice) {
    switch (choice) {
      case '1':
        return 'GitHub Actions';
      case '2':
        return 'GitLab CI';
      case '3':
        return 'Custom Script';
      default:
        return '';
    }
  }

  String _parseTool(String? choice) {
    switch (choice) {
      case '1':
        return 'Security Tools';
      case '2':
        return 'Performance Tools';
      case '3':
        return 'Integrations';
      default:
        return '';
    }
  }
}
