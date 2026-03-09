import 'package:ds_storage_base/ds_storage_base_export.dart';

import 'ds_storage_azure_provider.dart';

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

void registerAzureStorageProvider(Map<String, dynamic> config) {
  final provider = DSAzureBlobStorageProvider();

  DSStorageManager.registerProvider(
    _providerName(config, 'azure_blob'),
    provider,
    DSStorageProviderMetadata(
      type: 'azure_blob',
      region: _optionalString(config, 'region'),
      additionalMetadata: {
        if (config['container'] != null) 'container': config['container'],
        if (config['accountName'] != null) 'accountName': config['accountName'],
      },
    ),
  );
}
