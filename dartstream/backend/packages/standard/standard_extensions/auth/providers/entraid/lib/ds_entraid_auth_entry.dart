import 'package:ds_auth_base/ds_auth_base_export.dart';

import 'ds_entraid_auth_provider.dart';

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

Map<String, String>? _optionalStringMap(Map<String, dynamic> config, String key) {
  final value = config[key];
  if (value is Map) {
    return Map<String, String>.from(value);
  }
  return null;
}

List<String>? _optionalStringList(Map<String, dynamic> config, String key) {
  final value = config[key];
  if (value is List) {
    return value.whereType<String>().toList();
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

void registerEntraIdProvider(Map<String, dynamic> config) {
  final clientId = _requireString(config, 'clientId');
  final provider = DSEntraIDAuthProvider(
    tenantId: _requireString(config, 'tenantId'),
    clientId: clientId,
    clientSecret: _requireString(config, 'clientSecret'),
    primaryUserFlow: _optionalNullableString(config, 'primaryUserFlow') ??
        'B2C_1_signup_signin',
    domain: _optionalNullableString(config, 'domain'),
    userFlows: _optionalStringMap(config, 'userFlows'),
    scopes: _optionalStringList(config, 'scopes'),
  );

  DSAuthManager.registerProvider(
    _providerName(config, 'entraid'),
    provider,
    DSAuthProviderMetadata(
      type: 'entraid',
      region: _optionalString(config, 'region'),
      clientId: clientId,
    ),
  );
}
