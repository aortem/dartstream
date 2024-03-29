// This is the base command

import 'package:cli_util/cli_logging.dart';
import '../ds_config.dart';

abstract class DSBaseCommand {
  late Logger logger;

  DSBaseCommand() {
    // Initialize logger based on the configuration
    logger = DSConfig.verboseLogging ? Logger.verbose() : Logger.standard();
  }

  // Method to execute the command. Must be implemented by subclasses.
  void run();
}
