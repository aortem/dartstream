// Core CLI functionalities

import 'package:ds_tools_cli/ds_tools_cli.dart';

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
  final name = "sample";
  @override
  final description = "Runs core functionality.";

  DSInitCommand() {
    // Command specific arguments
  }

  @override
  void run() => DSInit().run();
}
