import 'package:ds_feature_flags_base/ds_feature_flag_base_export.dart';

import 'ds_flagd_provider.dart';

String _requireString(Map<String, dynamic> config, String key) {
  final value = config[key];
  if (value is String && value.isNotEmpty) {
    return value;
  }
  throw ArgumentError('Missing required config: $key');
}

String _optionalString(
  Map<String, dynamic> config,
  String key, {
  required String fallback,
}) {
  final value = config[key];
  return value is String && value.isNotEmpty ? value : fallback;
}

int _optionalInt(
  Map<String, dynamic> config,
  String key, {
  required int fallback,
}) {
  final value = config[key];
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

Future<void> registerFlagdProvider(Map<String, dynamic> config) async {
  final host = _requireString(config, 'host');
  final port = _optionalInt(config, 'port', fallback: 8013);
  final scheme = _optionalString(config, 'scheme', fallback: 'http');
  final apiPath =
      _optionalString(config, 'apiPath', fallback: '/ofrep/v1/evaluate/flags');

  final provider = DSFlagdProvider(
    baseUri: Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: apiPath,
    ),
  );
  DSFeatureFlagManager.registerProvider('flagd', provider);
}
