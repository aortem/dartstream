// Utilities For CLI functionalities

import 'package:args/command_runner.dart';

class DSUtilities {
  void run() {
    print("Running extended functionality...");
  }

  String performAction() {
    return "Expected Result"; //For testing Only
  }
}

class DSUtilitiesCommand extends Command {
  @override
  final name = "utilities";
  @override
  final description = "Runs utility functionality.";

  DSUtilitiesCommand() {
    // Command specific arguments
  }

  @override
  void run() => DSUtilities().run();
}
