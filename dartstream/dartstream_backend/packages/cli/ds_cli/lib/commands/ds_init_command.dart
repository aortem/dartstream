import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:ds_cli_util/ds_cli_utils.dart';

class DSInitCommand extends Command {
  @override
  final name = 'init';
  @override
  final description = 'Initialize a new Dartstream project.';

  DSInitCommand() {
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
      'version',
      abbr: 'v',
      defaultsTo: '',
      help: 'Specify the project version.',
    );
  }

  @override
  void run() {
    this.execute();
  }

  void execute({String Function()? readLineCallback}) {
    print('Initializing project...');

    var name = argResults?['name'];
    var version = argResults?['version'];

    var read = readLineCallback ?? stdin.readLineSync;

    if (name.isEmpty) {
      stdout.write('Enter project name: ');
      name = read();

      if (name.length == 0) {
        name = 'Dartstream Project';
      }
    }

    if (version.isEmpty) {
      stdout.write('Select version (1. Beta, 2. Stable): ');
      version = read();
    }

    var projectType = version == '1' ? 'Beta' : 'Stable';

    // Initialize project configuration (pseudo-code)
    // var config = ProjectConfig(projectName: projectName, projectType: projectType);
    // DartstreamCore core = DartstreamCore(config: config);
    // core.initializeCore();

    createProject(name: name, version: version);

    print('Project "$name" initialized with version $projectType.');
  }
}
