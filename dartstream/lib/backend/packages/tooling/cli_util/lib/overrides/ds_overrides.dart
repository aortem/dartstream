// Overrides to core CLI functionalities

import 'package:args/command_runner.dart';

class DSOverrides {
  void run() {
    print("Running extended functionality...");
  }
}

class DSOverridesCommand extends Command {
  @override
  final name = "extend";
  @override
  final description = "Runs extended functionality.";

  DSOverridesCommand() {
    // Command specific arguments
  }

  @override
  void run() => DSOverrides().run();
}
