// DESCRIPTION: Entry point for DartStream CLI. Dispatches commands based on user input.
// ============================
import 'package:ds_cli/command_registry.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    print('❌ No command provided.\nUse `ds help` to see available commands.');
    return;
  }

  final command = args.first;
  final run = commandRegistry[command];

  if (run == null) {
    print('❌ Unknown command: $command');
  } else {
    run();
  }
}
