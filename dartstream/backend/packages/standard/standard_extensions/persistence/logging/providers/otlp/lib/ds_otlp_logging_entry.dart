import 'package:ds_logging_base/ds_logging_base_export.dart';

import 'ds_otlp_logging_provider.dart';

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

void registerOtlpLoggingProvider(Map<String, dynamic> config) {
  final provider = DSOtlpLoggingProvider();

  DSLoggingManager.registerProvider(
    _providerName(config, 'otlp'),
    provider,
    DSLoggingProviderMetadata(
      type: 'opentelemetry',
      region: _optionalString(config, 'region'),
      additionalMetadata: {
        if (config['endpoint'] != null) 'endpoint': config['endpoint'],
      },
    ),
  );
}
