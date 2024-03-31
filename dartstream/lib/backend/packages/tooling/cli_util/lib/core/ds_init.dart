// Core CLI functionalities

import 'package:args/command_runner.dart';

class DSInit {
  void run() {
    print("Running core functionality...");
  }

  String performAction() {
    return "Expected Result"; //For testing Only
  }
}

class DSInitCommand extends Command {
  @override
  final name = "core";
  @override
  final description = "Runs core functionality.";

  DSInitCommand() {
    // Command specific arguments
  }

  @override
  void run() => DSInit().run();
}
