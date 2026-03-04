// backend/bin/sync_extensions.dart

import 'dart:io';
import 'package:yaml/yaml.dart';

Future<void> main() async {
  final registryPath = 'dartstream_registry.yaml';
  final configPath = 'packages/config/registered_extensions.yaml';

  final registryFile = File(registryPath);
  if (!await registryFile.exists()) {
    print('Registry file not found: $registryPath');
    print('Run: dart run bin/generate_registry.dart first');
    exit(1);
  }

  final registryContent = await registryFile.readAsString();
  final registry = loadYaml(registryContent) as YamlMap;
  final extensions = registry['extensions'] as YamlList?;

  if (extensions == null || extensions.isEmpty) {
    print('No extensions found in registry');
    exit(1);
  }

  final configFile = File(configPath);
  final existingByFullName = <String, Map<String, dynamic>>{};

  if (await configFile.exists()) {
    final configContent = await configFile.readAsString();
    final config = loadYaml(configContent) as YamlMap;

    config.forEach((category, data) {
      if (data is YamlMap && data.containsKey('providers')) {
        final providers = data['providers'] as YamlList;
        for (final provider in providers) {
          final fullName = (provider['full_name'] ?? provider['name'])?.toString() ?? '';
          if (fullName.isEmpty) continue;
          existingByFullName[fullName] = {
            'enabled': provider['enabled'] ?? false,
            'config': provider['config'] ?? {},
          };
        }
      }
    });
  }

  final grouped = <String, List<Map<String, dynamic>>>{};

  for (final ext in extensions) {
    final name = ext['name'] as String;
    final level = (ext['level'] as String?) ?? 'thirdParty';
    final type = (ext['type'] as String?) ?? _typeFromLevel(level);
    final optional = _asBool(ext['optional'], defaultValue: false);
    final compatible = _asBool(ext['compatible'], defaultValue: true);
    final path = (ext['path'] as String?) ?? _derivePath(name, _categorizeExtension(name, type));

    final category = _categorizeExtension(name, type, path: path);
    final enabled = existingByFullName[name]?['enabled'] ?? false;
    final config = existingByFullName[name]?['config'] ?? {};

    grouped.putIfAbsent(category, () => <Map<String, dynamic>>[]);
    grouped[category]!.add({
      'name': _extractShortName(name),
      'full_name': name,
      'version': ext['version'],
      'description': ext['description'],
      'path': path,
      'enabled': enabled,
      'level': level,
      'type': type,
      'optional': optional,
      'compatible': compatible,
      'config': config,
    });
  }

  final buffer = StringBuffer();
  buffer.writeln('# This file is beneficial for the following:');
  buffer.writeln('# We want to cache discovered extensions to avoid repeated scans.');
  buffer.writeln('# Provides a high-level view of all registered extensions.');
  buffer.writeln('# Provides a global configuration or dependency resolver.');
  buffer.writeln();

  final sortedCategories = grouped.keys.toList()..sort();

  for (final category in sortedCategories) {
    final providers = grouped[category]!;
    buffer.writeln('$category:');
    buffer.writeln('  providers:');

    for (final provider in providers) {
      buffer.writeln('    - name: ${provider['name']}');
      buffer.writeln('      full_name: ${provider['full_name']}');
      buffer.writeln('      version: ${provider['version']}');
      buffer.writeln('      description: "${provider['description']}"');
      buffer.writeln('      path: ${provider['path']}');
      buffer.writeln('      enabled: ${provider['enabled']}');
      buffer.writeln('      level: ${provider['level']}');
      buffer.writeln('      type: ${provider['type']}');
      buffer.writeln('      optional: ${provider['optional']}');
      buffer.writeln('      compatible: ${provider['compatible']}');

      if (provider['config'] != null && (provider['config'] as Map).isNotEmpty) {
        buffer.writeln('      config:');
        (provider['config'] as Map).forEach((key, value) {
          buffer.writeln('        $key: "$value"');
        });
      }
    }

    buffer.writeln();
  }

  await configFile.writeAsString(buffer.toString());
  print('Synced ${extensions.length} extensions to $configPath');
  print('Categories: ${sortedCategories.join(', ')}');
}

bool _asBool(Object? raw, {required bool defaultValue}) {
  if (raw is bool) return raw;
  if (raw is String) {
    final v = raw.toLowerCase();
    if (v == 'true') return true;
    if (v == 'false') return false;
  }
  return defaultValue;
}

String _categorizeExtension(String name, String type, {String path = ''}) {
  final lcName = name.toLowerCase();
  final lcType = type.toLowerCase();
  final lcPath = path.toLowerCase();

  if (lcType == 'plugin' || lcPath.contains('/enhanced/plugins/')) return 'plugins';
  if (lcName.contains('auth')) return 'auth';
  if (lcName.contains('database')) return 'database';
  if (lcName.contains('storage')) return 'storage';
  if (lcName.contains('logging')) return 'logging';
  if (lcName.contains('message_broker') || lcName.contains('pubsub')) return 'messaging';
  if (lcName.contains('websocket') || lcName.contains('socket')) return 'websockets';
  if (lcName.contains('events')) return 'events';
  if (lcName.contains('notifications')) return 'notifications';
  if (lcName.contains('feature') || lcName.contains('flag')) return 'feature_flags';
  if (lcName.contains('middleware') || lcName.contains('shelf')) return 'middleware';
  return 'general';
}

String _typeFromLevel(String level) {
  return level == 'core' ? 'core' : 'plugin';
}

String _extractShortName(String fullName) {
  return fullName
      .replaceAll('ds_', '')
      .replaceAll('ds_plugin_', '')
      .replaceAll('_provider', '')
      .replaceAll('_base', '')
      .replaceAll('_sdk', '');
}

String _derivePath(String name, String category) {
  if (name.contains('plugin') || name.startsWith('ds_plugin_')) {
    return 'packages/enhanced/plugins/${_extractShortName(name)}';
  }

  if (name.contains('auth') && !name.contains('base')) {
    final providerName = _extractShortName(name);
    return 'packages/standard/standard_extensions/auth/providers/$providerName';
  }
  if (name.contains('database') && !name.contains('base')) {
    final providerName = _extractShortName(name);
    return 'packages/standard/standard_extensions/persistence/database/providers/$providerName';
  }
  if (name.contains('storage') && !name.contains('base')) {
    final providerName = _extractShortName(name);
    return 'packages/standard/standard_extensions/persistence/storage/providers/$providerName';
  }
  if (name.contains('logging') && !name.contains('base')) {
    final providerName = _extractShortName(name);
    return 'packages/standard/standard_extensions/persistence/logging/providers/$providerName';
  }

  return 'packages/standard/standard_extensions/$category';
}
