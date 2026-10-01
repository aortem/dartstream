import 'dart:io';

import 'generated_file.dart';

/// Generates a local adapter; the application supplies every actual operation.
Future<File> generateProvider({
  required Directory project,
  required String name,
  String output = 'lib/src/providers',
}) async {
  final identifier = generatedName(name);
  final className = 'DS${identifier.className}Provider';
  return writeGeneratedFile(
    project: project,
    output: output,
    fileName: 'ds_${identifier.fileName}_provider.dart',
    content:
        '''
import 'dart:async';

/// Local callback adapter. The application owns lifecycle, policy and effects.
/// Wire real handlers explicitly; generation does not configure a vendor.
class $className {
  $className({
    required FutureOr<void> Function() onInitialize,
    required FutureOr<void> Function() onDispose,
    required FutureOr<void> Function(String action) onAction,
  }) : _onInitialize = onInitialize,
       _onDispose = onDispose,
       _onAction = onAction;

  final FutureOr<void> Function() _onInitialize;
  final FutureOr<void> Function() _onDispose;
  final FutureOr<void> Function(String action) _onAction;

  Future<void> initialize() async => await _onInitialize();
  Future<void> dispose() async => await _onDispose();
  Future<void> performAction(String action) async => await _onAction(action);
}
''',
  );
}
