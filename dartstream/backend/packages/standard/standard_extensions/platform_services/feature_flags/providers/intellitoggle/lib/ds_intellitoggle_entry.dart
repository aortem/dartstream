import 'package:ds_feature_flags_base/ds_feature_flag_base_export.dart';

import 'ds_intellitoggle_provider.dart';
import 'src/ds_intellitoggle_config.dart';

/// Helper to extract a required string from a config map.
String _requireString(Map<String, dynamic> config, String key) {
  final value = config[key];
  if (value is String && value.isNotEmpty) {
    return value;
  }
  throw ArgumentError('Missing required config: $key');
}

/// Helper to extract an optional string from a config map.
String _optionalString(Map<String, dynamic> config, String key,
    {String fallback = ''}) {
  final value = config[key];
  return value is String ? value : fallback;
}

/// Registers the IntelliToggle provider with DartStream's
/// feature flag manager.
///
/// Example usage:
/// ```dart
/// registerIntelliToggleProvider({
///   'clientId': Platform.environment['INTELLITOGGLE_CLIENT_ID']!,
///   'clientSecret': Platform.environment['INTELLITOGGLE_CLIENT_SECRET']!,
///   'tenantId': Platform.environment['INTELLITOGGLE_TENANT_ID']!,
///   'environment': 'production', // optional
/// });
/// ```
Future<void> registerIntelliToggleProvider(
    Map<String, dynamic> config) async {
  final clientId = _requireString(config, 'clientId');
  final clientSecret = _requireString(config, 'clientSecret');
  final tenantId = _requireString(config, 'tenantId');
  final environment = _optionalString(config, 'environment',
      fallback: 'production');

  // Select config preset based on environment
  final DSIntelliToggleConfig providerConfig;
  if (environment == 'development') {
    providerConfig = DSIntelliToggleConfig.development();
  } else {
    providerConfig = DSIntelliToggleConfig.production();
  }

  final provider = DSIntelliToggleProvider(
    clientId: clientId,
    clientSecret: clientSecret,
    tenantId: tenantId,
    config: providerConfig,
  );

  await provider.initialize();

  // Register provider without metadata (not supported in feature flags yet)
  DSFeatureFlagManager.registerProvider('intellitoggle', provider);
}