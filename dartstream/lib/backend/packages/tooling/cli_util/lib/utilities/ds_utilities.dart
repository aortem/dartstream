// Utilities For CLI functionalities

import 'package:args/command_runner.dart';

class DSUtilities {
  void run() {
    print("Running extended functionality...");
  }

  static void printMessage(String s) {}
}

class DSUtilitiesCommand extends Command {
  @override
  final name = "extend";
  @override
  final description = "Runs extended functionality.";

  DSUtilitiesCommand() {
    // Command specific arguments
  }

  @override
  void run() => DSUtilities().run();
}
