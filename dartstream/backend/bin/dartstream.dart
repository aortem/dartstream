import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:ds_dartstream/src/cli/dartstream_cli.dart';

Future<void> main(List<String> args) async {
  final runner = createDartStreamCommandRunner();

  try {
    await runner.run(args);
  } on UsageException catch (e) {
    stderr.writeln(e);
    exit(64);
  } catch (e) {
    stderr.writeln('An unexpected error occurred: $e');
    exit(1);
  }
}
