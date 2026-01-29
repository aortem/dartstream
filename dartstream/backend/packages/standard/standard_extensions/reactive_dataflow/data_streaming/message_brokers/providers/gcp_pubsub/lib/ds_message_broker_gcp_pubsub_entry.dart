import 'package:ds_message_broker_base/ds_message_broker_base_export.dart';

import 'ds_message_broker_gcp_pubsub_provider.dart';

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

String _projectId(Map<String, dynamic> config, String fallback) {
  final value = config['projectId'] ?? config['project'];
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  return fallback;
}

void registerGcpPubSubMessageBroker(Map<String, dynamic> config) {
  final provider = DSGcpPubSubMessageBrokerProvider();

  DSMessageBrokerManager.registerProvider(
    _providerName(config, 'pubsub'),
    provider,
    DSMessageBrokerProviderMetadata(
      type: 'pubsub',
      vendor: 'gcp',
      projectId: _projectId(config, 'default'),
      region: _optionalString(config, 'region'),
      additionalMetadata: {
        if (config['projectId'] != null) 'projectId': config['projectId'],
      },
    ),
  );
}
