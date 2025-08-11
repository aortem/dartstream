// Auto-generated provider configuration
// Created by Dartstream CLI

import 'package:ds_standard_engine/ds_standard_engine.dart';
import 'package:ds_firebase_auth_provider/ds_firebase_auth_provider.dart';
import 'package:ds_google_firebase_database/ds_google_firebase_database.dart';

Future<void> registerProviders(DSStandardCore core) async {
  // Register authentication provider
  core.registerCoreExtension(
    extension: DSFirebaseAuthProvider(),
    baseFeature: 'authentication',
  );
  
  // Register database provider
  core.registerCoreExtension(
    extension: DSFirebaseDatabase(),
    baseFeature: 'database',
  );
  
  print('✅ Providers registered successfully');
}
