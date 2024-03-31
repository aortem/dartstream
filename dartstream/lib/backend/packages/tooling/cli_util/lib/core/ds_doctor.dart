// Core CLI functionalities

import 'package:args/command_runner.dart';

class DSDoctor {
  void run() {
    print("Running core functionality...");
  }

  String performAction() {
    return "Expected Result"; //For testing Only
  }
}

class DSDoctorCommand extends Command {
  @override
  final name = "core";
  @override
  final description = "Runs core functionality.";

  DSDoctorCommand() {
    // Command specific arguments
  }

  @override
  void run() => DSDoctor().run();
}
