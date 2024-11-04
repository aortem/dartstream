import 'package:args/command_runner.dart';
import 'ds_commands/ds_init_command.dart';
import 'ds_commands/ds_configure_command.dart';
import 'ds_commands/ds_setup_command.dart';
import 'ds_commands/ds_generate_command.dart';

void main(List<String> arguments) {
  var runner = CommandRunner("ds", "DartStream CLI Tools")
    ..addCommand(DSInitCommand())
    ..addCommand(DSConfigureCommand())
    ..addCommand(DSSetupCommand())
    ..addCommand(DSGenerateCommand());

  runner.run(arguments).catchError((error) {
    print('Error: $error');
  });
}
