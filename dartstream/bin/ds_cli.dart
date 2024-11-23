import 'package:args/command_runner.dart';
import 'ds_commands/ds_init_command.dart';
import 'ds_commands/ds_configure_command.dart';
import 'ds_commands/ds_setup_command.dart';
import 'ds_commands/ds_generate_command.dart';
import 'ds_commands/ds_discover_command.dart'; // Import the new command

void main(List<String> arguments) {
  var runner = CommandRunner("ds", "DartStream CLI Tools")
    ..addCommand(DSInitCommand())
    ..addCommand(DSConfigureCommand())
    ..addCommand(DSSetupCommand())
    ..addCommand(DSGenerateCommand())
    ..addCommand(DSDiscoverCommand()); // Add the new command

  runner.run(arguments).catchError((error) {
    print('Error: $error');
  });
}
