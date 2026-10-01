import 'dart:io';

import 'generated_file.dart';

/// Generates a discoverable local package implementing the lifecycle contract.
Future<Directory> generateExtension({
  required Directory project,
  required String name,
  String output = 'packages',
}) async {
  final identifier = generatedName(name);
  final packageName = 'ds_${identifier.fileName}_extension';
  final className = 'DS${identifier.className}Extension';
  return writeGeneratedPackage(
    project: project,
    output: output,
    packageName: packageName,
    files: {
      'pubspec.yaml':
          '''
name: $packageName
description: Local ${identifier.className} extension for DartStream.
version: 0.0.1
publish_to: none
environment:
  sdk: ^3.12.2
dependencies:
  ds_lifecycle_base: ^0.0.2
''',
      'manifest.yaml':
          '''
name: $packageName
version: 0.0.1
level: third-party
entry_point: lib/$packageName.dart
dependencies: []
''',
      'lib/$packageName.dart':
          '''
import 'dart:async';

import 'package:ds_lifecycle_base/ds_lifecycle_base.dart';

/// Application-owned extension. Registration and authorization remain explicit.
class $className implements LifecycleHook {
  $className({
    required void Function() onInitialize,
    required void Function() onDispose,
    required void Function() onRegister,
    required void Function(Map<String, dynamic> config) onConfigUpdate,
    required FutureOr<void> Function(Map<String, dynamic> params) onExecute,
  }) : _initialize = onInitialize,
       _dispose = onDispose,
       _register = onRegister,
       _configUpdate = onConfigUpdate,
       _execute = onExecute;

  final void Function() _initialize;
  final void Function() _dispose;
  final void Function() _register;
  final void Function(Map<String, dynamic>) _configUpdate;
  final FutureOr<void> Function(Map<String, dynamic>) _execute;

  @override
  void onInitialize() => _initialize();
  @override
  void onDispose() => _dispose();
  @override
  void onRegister() => _register();
  @override
  void onConfigUpdate(Map<String, dynamic> config) => _configUpdate(config);

  Future<void> execute(Map<String, dynamic> params) async => await _execute(params);
}
''',
    },
  );
}
