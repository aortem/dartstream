import '../api/ds_cli_util.dart';

void main() {
  // Example using utilities
  DSUtilities.printMessage("This is an example utility message.");

  // Simulate running a command (would actually be run from the CLI)
  var coreCommand = DSCoreCommand();
  coreCommand.run();

  var extendCommand = DSExtensionsCommand();
  extendCommand.run();
}
