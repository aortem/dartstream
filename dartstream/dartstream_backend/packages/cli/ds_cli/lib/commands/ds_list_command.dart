import 'package:args/command_runner.dart';

import 'ds_init_command.dart';
import 'ds_configure_command.dart';
import 'ds_enable_extension_command.dart';
import 'ds_disable_extension_command.dart';
import 'ds_setup_command.dart';
import 'ds_discovery_command.dart';
import 'ds_generate_command.dart';
import 'ds_validate_command.dart';
import 'ds_extensions_command.dart';

/// CLI Command for listing all available commands.
class DSListCommand extends Command {
  @override
  final name = 'list';

  @override
  final description = 'Lists all available commands for Dartstream.';

  /// Constructor for initializing the list command.
  DSListCommand() {}

  @override
  void run() {
    List<Command> items = [
      DSInitCommand(),
      DSConfigureCommand(),
      DSEnableExtensionCommand(),
      DSDisableExtensionCommand(),
      DSSetupCommand(),
      DSDiscoveryCommand(),
      DSGenerateCommand(),
      DSValidateCommand(),
      DSExtensionsCommand(),
      DSListCommand(),
    ];

    print('\nUsage: dartstream <command> [arguments]');
    print('\nAvailable commands:');
    items.forEach((item) {
      print('  ' + item.name.padRight(25) + item.description);
    });
  }
}
