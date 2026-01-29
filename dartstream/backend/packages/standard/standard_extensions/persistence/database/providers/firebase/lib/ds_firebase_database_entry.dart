import 'package:ds_database_base/ds_database_base_export.dart';

import 'ds_firebase_database_provider.dart';

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

String _databaseId(Map<String, dynamic> config) {
  final value = config['databaseId'] ?? config['database'];
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  return '(default)';
}

String _projectId(Map<String, dynamic> config) {
  final value = config['projectId'] ?? config['project'];
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  return '';
}

void registerFirebaseDatabaseProvider(Map<String, dynamic> config) {
  final provider = DSFirebaseDatabaseProvider();

  DSDatabaseManager.registerProvider(
    _providerName(config, 'firestore'),
    provider,
    DSDatabaseProviderMetadata(
      type: 'firestore',
      region: _optionalString(config, 'region'),
      databaseId: _databaseId(config),
      additionalMetadata: {
        if (_projectId(config).isNotEmpty) 'projectId': _projectId(config),
      },
    ),
  );
}
