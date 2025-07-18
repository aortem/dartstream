// DESCRIPTION: Entry point for DartStream CLI. Dispatches commands based on user input.
// ============================

import 'package:args/command_runner.dart';

import '../lib/commands/ds_init_command.dart';
import '../lib/commands/ds_configure_command.dart';
import '../lib/commands/ds_enable_extension_command.dart';
import '../lib/commands/ds_disable_extension_command.dart';
import '../lib/commands/ds_setup_command.dart';
import '../lib/commands/ds_discovery_command.dart';
import '../lib/commands/ds_generate_command.dart';
import '../lib/commands/ds_validate_command.dart';
import '../lib/commands/ds_extensions_command.dart';
import '../lib/commands/ds_list_command.dart';

void main(List<String> args) async {
  // if (args.isEmpty) {
  //   print('❌ No command provided.\nUse `ds help` to see available commands.');
  //   return;
  // }

  // Create a CommandRunner
  final runner =
      CommandRunner<void>(
          'dartstream', // The name of your executable
          'Dartstream CLI tool.', // Its description
        )
        ..addCommand(DSInitCommand())
        ..addCommand(DSConfigureCommand())
        ..addCommand(DSEnableExtensionCommand())
        ..addCommand(DSDisableExtensionCommand())
        ..addCommand(DSSetupCommand())
        ..addCommand(DSDiscoveryCommand())
        ..addCommand(DSGenerateCommand())
        ..addCommand(DSValidateCommand())
        ..addCommand(DSExtensionsCommand())
        ..addCommand(DSListCommand());

  try {
    await runner.run(args);
  } on UsageException catch (e) {
    // print('❌ Unknown command: $command');
    // print('❌ No command provided.\nUse `ds help` to see available commands.');

    // The 'args' package will print the help text for you
    print(e);
    // Exit with a non-zero exit code
    // exit(64); // You may want to use dart:io's exit code for this
  } catch (e) {
    print('An unexpected error occurred: $e');
  }
}
