import 'package:ds_storage_base/ds_storage_base_export.dart';

import 'ds_storage_gcp_provider.dart';

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

void registerGcpStorageProvider(Map<String, dynamic> config) {
  final provider = DSGcpStorageProvider();

  DSStorageManager.registerProvider(
    _providerName(config, 'gcs'),
    provider,
    DSStorageProviderMetadata(
      type: 'gcs',
      region: _optionalString(config, 'region'),
      additionalMetadata: {
        if (config['bucket'] != null) 'bucket': config['bucket'],
        if (config['projectId'] != null) 'projectId': config['projectId'],
      },
    ),
  );
}
