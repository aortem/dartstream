import 'package:ds_auth_base/ds_auth_base_export.dart';

import 'ds_auth0_auth_provider.dart';

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

void registerAuth0Provider(Map<String, dynamic> config) {
  final clientId = _requireString(config, 'clientId');
  final provider = DSAuth0AuthProvider(
    domain: _requireString(config, 'domain'),
    clientId: clientId,
    clientSecret: _requireString(config, 'clientSecret'),
    audience: _requireString(config, 'audience'),
  );

  DSAuthManager.registerProvider(
    _providerName(config, 'auth0'),
    provider,
    DSAuthProviderMetadata(
      type: 'auth0',
      region: _optionalString(config, 'region'),
      clientId: clientId,
    ),
  );
}
