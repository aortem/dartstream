// ds_commands/ds_init_command.dart
import 'package:args/command_runner.dart';
import 'dart:io';

class DSInitCommand extends Command {
  @override
  final name = 'init';
  @override
  final description = 'Initialize a new Dartstream project.';

  DSInitCommand();

  @override
  void run() {
    this.execute();
  }

  void execute({String Function()? readLineCallback}) {
    print('Initializing project...');
    // Collect project name
    stdout.write('Enter project name: ');

    var read = readLineCallback ?? stdin.readLineSync;

    var projectName = read() ?? 'Dartstream Project';

    // Collect project type
    stdout.write('Select version (1. Beta, 2. Stable): ');
    var versionChoice = read();
    var projectType = versionChoice == '1' ? 'Beta' : 'Stable';

    // Initialize project configuration (pseudo-code)
    // var config = ProjectConfig(projectName: projectName, projectType: projectType);
    // DartstreamCore core = DartstreamCore(config: config);
    // core.initializeCore();

    print('Project "$projectName" initialized with version $projectType.');
  }
}
