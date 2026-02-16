import 'package:ds_auth_base/ds_auth_base_export.dart';

import 'ds_cognito_auth_provider.dart';

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

String? _optionalNullableString(Map<String, dynamic> config, String key) {
  final value = config[key];
  if (value is String && value.isNotEmpty) {
    return value;
  }
  return null;
}

String _providerName(Map<String, dynamic> config, String fallback) {
  final value = config['name'];
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  return fallback;
}

void registerCognitoProvider(Map<String, dynamic> config) {
  final clientId = _requireString(config, 'clientId');
  final provider = DSCognitoAuthProvider(
    userPoolId: _requireString(config, 'userPoolId'),
    clientId: clientId,
    region: _requireString(config, 'region'),
    clientSecret: _optionalNullableString(config, 'clientSecret'),
    identityPoolId: _optionalNullableString(config, 'identityPoolId'),
  );

  DSAuthManager.registerProvider(
    _providerName(config, 'cognito'),
    provider,
    DSAuthProviderMetadata(
      type: 'cognito',
      region: _optionalString(config, 'region'),
      clientId: clientId,
    ),
  );
}
