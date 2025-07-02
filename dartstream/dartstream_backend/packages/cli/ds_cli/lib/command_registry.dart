// DESCRIPTION: Registry mapping CLI commands to their handler functions.
// ============================

import 'package:ds_cli/commands/ds_list_command.dart';

import 'commands/ds_init_command.dart';
import 'commands/ds_configure_command.dart';
import 'commands/ds_enable_extension_command.dart';
import 'commands/ds_disable_extension_command.dart';
import 'commands/ds_setup_command.dart';
import 'commands/ds_discovery_command.dart';
import 'commands/ds_generate_command.dart';
import 'commands/ds_validate_command.dart';
import 'commands/ds_extensions_command.dart';

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
  DSExtensionsCommand().run();
}

void runListCommand() {
  DSListCommand().run();
}

final Map<String, void Function()> commandRegistry = {
  'init': runInitCommand,
  'configure': runConfigureCommand,
  'enable-extension': runEnableExtensionCommand,
  'disable-extension': runDisableExtensionCommand,
  'setup': runSetupCommand,
  'discovery': runDiscoveryCommand,
  'generate': runGenerateCommand,
  'validate': runValidateCommand,
  'extensions': runExtensionsCommand,
  'list': runListCommand,
};
