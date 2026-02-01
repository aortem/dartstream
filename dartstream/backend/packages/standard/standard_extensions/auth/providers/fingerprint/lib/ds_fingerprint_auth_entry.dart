import 'package:ds_auth_base/ds_auth_base_export.dart';

import 'ds_fingerprint_auth_provider.dart';

String _optionalString(Map<String, dynamic> config, String key) {
  final value = config[key];
  return value is String ? value : '';
}

String _providerName(Map<String, dynamic> config, String fallback) {
  final value = config['name'];
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  return fallback;
}

void registerFingerprintProvider(Map<String, dynamic> config) {
  final provider = DSFingerprintAuthProvider();

  DSAuthManager.registerProvider(
    _providerName(config, 'fingerprint'),
    provider,
    DSAuthProviderMetadata(
      type: 'fingerprint',
      region: _optionalString(config, 'region'),
      clientId: _optionalString(config, 'clientId'),
    ),
  );
}
