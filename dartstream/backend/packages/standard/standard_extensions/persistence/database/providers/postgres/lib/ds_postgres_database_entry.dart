import 'package:ds_database_base/ds_database_base_export.dart';

import 'ds_postgres_database_provider.dart';

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

String _databaseId(Map<String, dynamic> config, String fallback) {
  final value = config['databaseId'] ?? config['database'] ?? config['dbName'];
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  return fallback;
}

void registerPostgresDatabaseProvider(Map<String, dynamic> config) {
  final provider = DSPostgresDatabaseProvider();

  DSDatabaseManager.registerProvider(
    _providerName(config, 'postgres'),
    provider,
    DSDatabaseProviderMetadata(
      type: 'postgres',
      region: _optionalString(config, 'region'),
      databaseId: _databaseId(config, 'default'),
      additionalMetadata: {
        if (config['host'] != null) 'host': config['host'],
        if (config['database'] != null) 'database': config['database'],
        if (config['url'] != null) 'url': config['url'],
      },
    ),
  );
}
