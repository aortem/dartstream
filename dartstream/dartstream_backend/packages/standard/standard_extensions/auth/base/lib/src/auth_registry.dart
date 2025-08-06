// GENERATED CODE – DO NOT EDIT
// packages/standard/standard_extensions/auth/base/lib/src/auth_registry.dart

import 'package:ds_auth_base/ds_auth_base_export.dart';
// Import for Auth0 provider
import 'package:ds_auth0_auth_provider/ds_auth0_auth_export.dart';
// Import for Firebase provider
import 'package:ds_firebase_auth_provider/ds_firebase_auth_export.dart';
// Import for Magic provider
import 'package:ds_magic_auth_provider/ds_magic_auth_export.dart';
// Import for Transmit provider
import 'package:ds_transmit_auth_provider/ds_transmit_auth_export.dart';
// Import for Fingerprint provider
import 'package:ds_fingerprint_auth_provider/ds_fingerprint_auth_provider.dart';
// …more imports for each provider as needed

void registerAllAuthProviders() {
  DSAuthManager.registerProvider(
    'cognito',
    DSAuth0AuthProvider(
      domain: '', // set via config or env
      clientId: '', // set via config or env
      clientSecret: '', // set via config or env
      audience: '' // set via config or env
    ),
    DSAuthProviderMetadata(type: 'cognito', region: 'us-east-1', clientId: ''),
  );
  DSAuthManager.registerProvider(
    'firebase',
    DSFirebaseAuthProvider(
      projectId: '', // set via config or env
      privateKeyPath: '',  // set via config or env
      apiKey: '' // set via config or env
    ),
    DSAuthProviderMetadata(
      type: 'firebase',
      region: 'us-central1',
      clientId: '',
    ),
  );
  // Magic Auth provider (update the metadata as relevant for your integration)
  DSAuthManager.registerProvider(
    'magic',
    DSMagicAuthProvider(
      publishableKey: '', // set via config or env
      secretKey: '', // set via config or env
    ),
    DSAuthProviderMetadata(type: 'magic', region: '', clientId: ''),
  );

  // Transmit Auth provider (update the metadata as relevant for your integration)
  DSAuthManager.registerProvider(
    'transmit',
    DSTransmitAuthProvider(),
    DSAuthProviderMetadata(type: 'transmit', region: '', clientId: ''),
  );

  // Fingerprint Auth provider (update the metadata as relevant for your integration)
  DSAuthManager.registerProvider(
    'fingerprint',
    DSFingerprintAuthProvider(
      apiKey: '', // set via config or env
    ),
    DSAuthProviderMetadata(type: 'fingerprint', region: '', clientId: ''),
  );
  // …register more providers as new ones are added
}
