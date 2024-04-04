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
  final name = "rename";
  @override
  final description = "Runs rename/refactor functionality.";

  DSRenameCommand() {
    // Command specific arguments
  }

  @override
  void run() => DSRename().run();
}
