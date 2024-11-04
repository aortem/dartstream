// ds_commands/ds_setup_command.dart
import 'package:args/command_runner.dart';

class DSSetupCommand extends Command {
  @override
  final name = 'setup';
  @override
  final description = 'Set up middleware, CI/CD, and additional tools.';

  DSSetupCommand();

  @override
  void run() {
    print('Setting up project components...');

    // Middleware Selection
    stdout.write('Choose middleware (1. Dartstream, 2. Shelf, 3. Custom): ');
    var middlewareChoice = stdin.readLineSync();
    var middleware = _parseMiddleware(middlewareChoice);

    // CI/CD Tool Selection
    stdout.write(
        'Choose CI/CD tool (1. GitHub Actions, 2. GitLab CI, 3. Custom Script): ');
    var ciCdChoice = stdin.readLineSync();
    var ciCdTool = _parseCiCdTool(ciCdChoice);

    // Custom Tools Selection
    stdout
        .write('Select tools (1. Security, 2. Performance, 3. Integrations): ');
    var toolsChoice = stdin.readLineSync()?.split(',').map(_parseTool).toList();

    print("Middleware: $middleware");
    print("CI/CD: $ciCdTool");
    print("Tools: ${toolsChoice?.join(', ')}");
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
