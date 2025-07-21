// ds_commands/ds_configure_command.dart
import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:ds_cli_util/ds_cli_utils.dart';

class DSConfigureCommand extends Command {
  @override
  final name = 'configure';
  @override
  final description =
      'Configure core project components like cloud provider and framework.';

  DSConfigureCommand() {
    argParser.addOption(
      'name',
      abbr: 'n',
      defaultsTo: '',
      help: 'Specify the project name.',
    );
    argParser.addOption(
      'framework',
      abbr: 'f',
      defaultsTo: '',
      help: 'Specify the framework.',
    );
    argParser.addOption(
      'vendor',
      abbr: 'v',
      defaultsTo: '',
      help: 'Specify the cloud vendor.',
    );
    argParser.addOption(
      'auth',
      abbr: 'a',
      defaultsTo: '',
      help: 'Specify the authentication provider.',
    );
    argParser.addOption(
      'cicd',
      abbr: 'c',
      defaultsTo: '',
      help: 'Specify the CI/CD tool.',
    );
  }

  @override
  void run() {
    this.execute();
  }

  void execute({String Function()? readLineCallback}) {
    print('Configuring project...');

    var name = argResults?['name'];
    var frameworkChoice = argResults?['framework'];
    var vendorChoice = argResults?['vendor'];
    var authChoice = argResults?['auth'];
    var ciCdChoice = argResults?['cicd'];

    var read = readLineCallback ?? stdin.readLineSync;

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

    if (vendorChoice.isEmpty) {
      // Cloud Vendor Selection
      stdout.write(
        'Select cloud vendor (1. Google Cloud, 2. AWS, 3. Azure, 4. Local): ',
      );

      vendorChoice = read();
    }

    var cloudVendor = _parseCloudVendor(vendorChoice);

    // CI/CD Tool Selection
    if (ciCdChoice.isEmpty) {
      stdout.write(
        'Choose CI/CD tool (1. GitHub Actions, 2. GitLab CI, 3. Custom Script): ',
      );
      ciCdChoice = read();
    }

    var ciCdTool = _parseCiCdTool(ciCdChoice);

    if (frameworkChoice.isEmpty) {
      // Framework Selection
      stdout.write(
        'Select framework (1. Dart Web, 2. Flutter, 3. Vue.js, 4. Svelte): ',
      );
      frameworkChoice = read();
    }

    var framework = _parseFramework(frameworkChoice);

    if (authChoice.isEmpty) {
      // Authentication Selection
      stdout.write(
        'Select authentication provider (1. Firebase, 2. AWS Cognito, 3. Azure AD): ',
      );
      authChoice = read();
    }

    var authProvider = _parseAuthProvider(authChoice);

    print('''

This will be your new configuration:
Cloud Vendor: $cloudVendor
Framework: $framework
Authentication Provider: $authProvider
CI/CD tool: $ciCdTool

Do you want to proceed with these settings? Yes(Y) / No(N): ''');

    var confirmation = read()?.toLowerCase();

    if (confirmation != 'y') {
      print('Configuration cancelled.');
      return;
    }

    saveProjectConfig(
      name: name,
      content: {
        'vendorChoice': vendorChoice,
        'frameworkChoice': frameworkChoice,
        'authChoice': authChoice,
        'ciCdChoice': ciCdChoice,
      },
    );

    generateCICDFiles(projectName: name, ciCdChoice: ciCdChoice);

    print('Configuration updated.');
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

  String _parseCloudVendor(String? choice) {
    switch (choice) {
      case '1':
        return 'Google Cloud';
      case '2':
        return 'AWS';
      case '3':
        return 'Azure';
      default:
        return 'Local';
    }
  }

  String _parseFramework(String? choice) {
    switch (choice) {
      case '1':
        return 'Dart Web';
      case '2':
        return 'Flutter';
      case '3':
        return 'Vue.js';
      case '4':
        return 'Svelte';
      default:
        return '';
    }
  }

  String _parseAuthProvider(String? choice) {
    switch (choice) {
      case '1':
        return 'Firebase Authentication';
      case '2':
        return 'AWS Cognito';
      case '3':
        return 'Azure Active Directory';
      default:
        return '';
    }
  }
}
