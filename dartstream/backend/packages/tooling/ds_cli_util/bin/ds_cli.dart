// Uses 'package:args/command_runner.dart' for parsing and executing commands.

import 'package:args/command_runner.dart';
import '../lib/ds_cli_util.dart';

//import 'create_project_command.dart';

// Import DSInitCommand

void main(List<String> arguments) {
  var runner = CommandRunner("ds", "DartStream CLI Tools")
    //Core Commands
    ..addCommand(DSCoreCommand())
    ..addCommand(DSDeployCommand())
    ..addCommand(DSDoctorCommand())
    ..addCommand(DSInitCommand())
    ..addCommand(DSMakeCommand())
    ..addCommand(DSRenameCommand())

    //Extension Commands
    ..addCommand(DSExtensionsCommand())

    //Override Commands
    ..addCommand(DSOverridesCommand())

    //Utilities Commands
    ..addCommand(DSUtilitiesCommand())

    //Middleware Options
    ..addCommand(DSCreateShelfCommand());

  runner.run(arguments).catchError((error) {
    print('Error: $error');
  });
}
