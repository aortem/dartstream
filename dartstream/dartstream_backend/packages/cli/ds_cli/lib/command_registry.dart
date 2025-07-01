// DESCRIPTION: Registry mapping CLI commands to their handler functions.
// ============================

import 'package:args/command_runner.dart';

import './commands/ds_init_command.dart';
import './commands/ds_configure_command.dart';
import './commands/ds_enable_extension_command.dart';
import './commands/ds_disable_extension_command.dart';
import './commands/ds_setup_command.dart';
import './commands/ds_discovery_command.dart';
import './commands/ds_generate_command.dart';
import './commands/ds_validate_command.dart';
import './commands/ds_list_extensions_command.dart';

void runInitCommand() {
  DSInitCommand().run();
}

void runConfigureCommand() {
  DSConfigureCommand().run();
}

void runEnableExtensionCommand() {
  DSEnableExtensionCommand().run();
}

void runDisableExtensionCommand() {
  DSDisableExtensionCommand().run();
}

void runSetupCommand() {
  DSSetupCommand().run();
}

void runDiscoveryCommand() {
  DSDiscoveryCommand().run();
}

void runGenerateCommand() {
  DSGenerateCommand().run();
}

void runValidateCommand() {
  DSValidateCommand().run();
}

void runExtensionsCommand() {
  DSListExtensionsCommand().run();
}

void runListCommand() {
  List<Command> items = [
    DSInitCommand(),
    DSConfigureCommand(),
    DSEnableExtensionCommand(),
    DSDisableExtensionCommand(),
    DSSetupCommand(),
    DSDiscoveryCommand(),
    DSGenerateCommand(),
    DSValidateCommand(),
    DSListExtensionsCommand(),
  ];

  print('\nUsage: dartstream <command> [arguments]');
  print('\nAvailable commands:');
  items.forEach((item) {
    print('  ' + item.name.padRight(25) + item.description);
  });
}

final Map<String, void Function()> commandRegistry = {
  'init': runInitCommand,
  'configure': runConfigureCommand,
  'enable': runEnableExtensionCommand,
  'disable': runDisableExtensionCommand,
  'setup': runSetupCommand,
  'discovery': runDiscoveryCommand,
  'generate': runGenerateCommand,
  'validate': runValidateCommand,
  'extensions': runExtensionsCommand,
  'list': runListCommand,
};
