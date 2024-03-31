// Uses 'package:args/command_runner.dart' for parsing and executing commands.

import 'package:args/command_runner.dart';
import '../api/ds_cli_util.dart';

void main(List<String> arguments) {
  var runner = CommandRunner("ds", "DartStream CLI Tools")
    ..addCommand(DSCoreCommand())
    ..addCommand(DSExtensionsCommand());

  runner.run(arguments).catchError((error) {
    print('Error: $error');
  });
}
