// Extensions to core CLI functionalities

import 'package:args/command_runner.dart';

class DSExtensions {
  void run() {
    print("Running extended functionality...");
  }
}

class DSExtensionsCommand extends Command {
  @override
  final name = "extend";
  @override
  final description = "Runs extended functionality.";

  DSExtensionsCommand() {
    // Command specific arguments
  }

  @override
  void run() => DSExtensions().run();
}
