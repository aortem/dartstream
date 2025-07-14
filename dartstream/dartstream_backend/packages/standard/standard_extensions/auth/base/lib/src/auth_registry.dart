// GENERATED CODE – DO NOT EDIT
// packages/standard/standard_extensions/auth/base/lib/src/auth_registry.dart

import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_auth_cognito/ds_auth_cognito_export.dart';
import 'package:ds_auth_firebase/ds_auth_firebase_export.dart';
// …more imports for each provider

void registerAllAuthProviders() {
  DSAuthManager.registerProvider(
    'cognito',
    DSCognitoAuthProvider(),
    DSAuthProviderMetadata(type: 'cognito', region: 'us-east-1', clientId: ''),
  );
  DSAuthManager.registerProvider(
    'firebase',
    DSFirebaseAuthProvider(),
    DSAuthProviderMetadata(
      type: 'firebase',
      region: 'us-central1',
      clientId: '',
    ),
  );
  // …and so on
}
