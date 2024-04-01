// Overrides to core CLI functionalities

import 'package:args/command_runner.dart';

class DSOverrides {
  void run() {
    print("Running extended functionality...");
  }
}

class DSOverridesCommand extends Command {
  @override
  final name = "override";
  @override
  final description = "Runs overrides functionality.";

  DSOverridesCommand() {
    // Command specific arguments
  }

  @override
  void run() => DSOverrides().run();
}
