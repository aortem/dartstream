import 'package:flutter/material.dart';
import 'package:ds_standard_engine/ds_standard_engine.dart';
import 'src/core/app_core.dart';
import 'src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dartstream Standard Engine
  final core = DSStandardCore(
    projectConfig: {
      'name': 'test_project',
      'version': 'stable',
      'framework': 'flutter_mobile',
      'created': DateTime.now().toIso8601String(),
    },
  );

  await core.initialize();

  // Initialize app-specific core
  final app = AppCore(core: core);
  await app.start();

  print('🚀 test_project is running with Dartstream + Ping Identity!');

  // Run Flutter app with Ping Identity integration
  runApp(const App());
}
