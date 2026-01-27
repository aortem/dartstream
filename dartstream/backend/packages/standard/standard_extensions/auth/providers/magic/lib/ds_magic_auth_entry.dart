import 'package:ds_auth_base/ds_auth_base_export.dart';

import 'ds_magic_auth_provider.dart';

String _requireString(Map<String, dynamic> config, String key) {
  final value = config[key];
  if (value is String && value.isNotEmpty) {
    return value;
  }
  throw ArgumentError('Missing required config: ' + key);
}

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

void registerMagicProvider(Map<String, dynamic> config) {
  final clientId = _optionalString(config, 'clientId');
  final provider = DSMagicAuthProvider(
    publishableKey: _requireString(config, 'publishableKey'),
    secretKey: _requireString(config, 'secretKey'),
  );

  DSAuthManager.registerProvider(
    _providerName(config, 'magic'),
    provider,
    DSAuthProviderMetadata(
      type: 'magic',
      region: _optionalString(config, 'region'),
      clientId: clientId,
    ),
  );
}
