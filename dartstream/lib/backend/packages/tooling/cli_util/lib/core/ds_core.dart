// Core CLI functionalities

import 'package:args/command_runner.dart';

class DSCore {
  void run() {
    print("Running core functionality...");
  }

  String performAction() {
    return "Expected Result"; //For testing Only
  }
}

class DSCoreCommand extends Command {
  @override
  final name = "core";
  @override
  final description = "Runs core functionality.";

  DSCoreCommand() {
    // Command specific arguments
  }

  @override
  void run() => DSCore().run();
}
