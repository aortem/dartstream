import 'package:args/command_runner.dart';
import 'ds_commands/ds_init_command.dart';
import 'ds_commands/ds_configure_command.dart';
import 'ds_commands/ds_setup_command.dart';
import 'ds_commands/ds_generate_command.dart';
import 'ds_commands/ds_discovery_command.dart';
import 'ds_commands/ds_list_extensions_command.dart';
import 'ds_commands/ds_validate_command.dart';

void main(List<String> arguments) {
  var runner = CommandRunner("ds", "DartStream CLI Tools")
    ..addCommand(DSInitCommand())
    ..addCommand(DSConfigureCommand())
    ..addCommand(DSSetupCommand())
    ..addCommand(DSGenerateCommand())
    ..addCommand(DSDiscoveryCommand())
    ..addCommand(DSListExtensionsCommand())
    ..addCommand(DSValidateCommand());

  runner.run(arguments).catchError((error) {
    print('Error: $error');
  });
}
