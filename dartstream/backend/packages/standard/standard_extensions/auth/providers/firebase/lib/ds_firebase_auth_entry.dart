import 'package:ds_auth_base/ds_auth_base_export.dart';

import 'ds_firebase_auth_provider.dart';

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

void registerFirebaseProvider(Map<String, dynamic> config) {
  final projectId = _requireString(config, 'projectId');
  final clientId = _optionalString(config, 'clientId');
  final provider = DSFirebaseAuthProvider(
    projectId: projectId,
    privateKeyPath: _requireString(config, 'privateKeyPath'),
    apiKey: _requireString(config, 'apiKey'),
  );

  DSAuthManager.registerProvider(
    _providerName(config, 'firebase'),
    provider,
    DSAuthProviderMetadata(
      type: 'firebase',
      region: _optionalString(config, 'region'),
      clientId: clientId.isNotEmpty ? clientId : projectId,
    ),
  );
}
