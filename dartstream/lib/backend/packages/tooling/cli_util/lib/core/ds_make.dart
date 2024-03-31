// Core CLI functionalities

import 'package:args/command_runner.dart';

class DSMake {
  void run() {
    print("Running core functionality...");
  }

  String performAction() {
    return "Expected Result"; //For testing Only
  }
}

class DSMakeCommand extends Command {
  @override
  final name = "core";
  @override
  final description = "Runs core functionality.";

  DSMakeCommand() {
    // Command specific arguments
  }

  @override
  void run() => DSMake().run();
}
