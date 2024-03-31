// Uses 'package:args/command_runner.dart' for parsing and executing commands.

import 'package:args/command_runner.dart';
import 'package:ds_cli/api/ds_cli_util.dart';

void main(List<String> arguments) {
  var runner = CommandRunner("ds", "DartStream CLI Tools")
    //Core Commands
    ..addCommand(DSCoreCommand())
    ..addCommand(DSDeployCommand())
    ..addCommand(DSDoctorCommand())
    ..addCommand(DSMakeCommand())
    ..addCommand(DSRenameCommand())

    //Extension Commands
    ..addCommand(DSExtensionsCommand())

    //Override Commands
    ..addCommand(DSOverridesCommand())

    //Utilities Commands
    ..addCommand(DSUtilitiesCommand());

  runner.run(arguments).catchError((error) {
    print('Error: $error');
  });
}
