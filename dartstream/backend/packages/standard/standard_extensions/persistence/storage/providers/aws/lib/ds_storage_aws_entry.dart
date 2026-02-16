import 'package:ds_storage_base/ds_storage_base_export.dart';

import 'ds_storage_aws_provider.dart';

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

void registerAwsStorageProvider(Map<String, dynamic> config) {
  final provider = DSAwsStorageProvider();

  DSStorageManager.registerProvider(
    _providerName(config, 's3'),
    provider,
    DSStorageProviderMetadata(
      type: 's3',
      region: _optionalString(config, 'region'),
      additionalMetadata: {
        if (config['bucket'] != null) 'bucket': config['bucket'],
        if (config['endpoint'] != null) 'endpoint': config['endpoint'],
        if (config['endPoint'] != null) 'endPoint': config['endPoint'],
      },
    ),
  );
}
