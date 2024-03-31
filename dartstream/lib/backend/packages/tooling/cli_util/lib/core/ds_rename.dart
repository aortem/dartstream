// Core CLI functionalities

import 'package:args/command_runner.dart';

class DSRename {
  void run() {
    print("Running core functionality...");
  }

  String performAction() {
    return "Expected Result"; //For testing Only
  }
}

class DSRenameCommand extends Command {
  @override
  final name = "core";
  @override
  final description = "Runs core functionality.";

  DSRenameCommand() {
    // Command specific arguments
  }

  @override
  void run() => DSRename().run();
}
