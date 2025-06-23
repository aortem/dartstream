// DESCRIPTION: Registry mapping CLI commands to their handler functions.
// ============================
import 'commands/ds_init_command.dart';
import 'commands/ds_configure_command.dart';
import 'commands/ds_enable_extension_command.dart';
import 'commands/ds_disable_extension_command.dart';
import 'commands/ds_setup_command.dart';
import 'commands/ds_discovery_command.dart';
import 'commands/ds_generate_command.dart';
import 'commands/ds_validate_command.dart';
import 'commands/ds_list_extensions_command.dart';

final Map<String, void Function()> commandRegistry = {
  'init': runInitCommand,
  'configure': runConfigureCommand,
  'enable': runEnableExtensionCommand,
  'disable': runDisableExtensionCommand,
  'setup': runSetupCommand,
  'discovery': runDiscoveryCommand,
  'generate': runGenerateCommand,
  'validate': runValidateCommand,
  'list': runListExtensionsCommand,
};
