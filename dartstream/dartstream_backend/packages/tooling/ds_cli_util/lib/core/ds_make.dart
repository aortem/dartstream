// Core CLI functionalities

import 'package:ds_tools_cli/ds_tools_cli.dart';

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
  final name = "make";
  @override
  final description = "Runs make functionality.";

  DSMakeCommand() {
    // Command specific arguments
  }

  @override
  void run() => DSMake().run();
}
