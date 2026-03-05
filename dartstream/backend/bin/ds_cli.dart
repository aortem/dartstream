// backend/bin/ds_cli.dart

import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:args/args.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addCommand('list-extensions', ArgParser()
      ..addOption(
        'type',
        help: 'Filter extension type',
        allowed: ['all', 'plugin', 'core', 'provider'],
        defaultsTo: 'all',
      ))
    ..addCommand('enable-plugin')
    ..addCommand('disable-plugin');

  try {
    final results = parser.parse(arguments);
    final command = results.command?.name;

    if (command == null) {
      _printUsage();
      return;
    }

    switch (command) {
      case 'list-extensions':
        await _listExtensions(results.command!);
        break;
      case 'enable-plugin':
        await _enablePlugin(results.command!);
        break;
      case 'disable-plugin':
        await _disablePlugin(results.command!);
        break;
      default:
        print('Unknown command: $command');
        _printUsage();
    }
  } catch (e) {
    print('Error: $e');
    _printUsage();
    exit(1);
  }
}

void _printUsage() {
  print('''
DartStream CLI - Plugin Management

Usage:
  dart bin/ds_cli.dart <command> [arguments]

Commands:
  list-extensions [--type=plugin]   List available extensions (filter optional)
  enable-plugin <name>              Enable a specific plugin
  disable-plugin <name>             Disable a specific plugin

Examples:
  dart bin/ds_cli.dart list-extensions
  dart bin/ds_cli.dart list-extensions --type=plugin
  dart bin/ds_cli.dart enable-plugin ds_plugin_third_party_plugin_1
  dart bin/ds_cli.dart disable-plugin ds_plugin_third_party_plugin_1
''');
}

Future<void> _listExtensions(ArgResults results) async {
  final config = await _loadConfig();
  final typeFilter = (results['type'] as String?) ?? 'all';

  print('\nDartStream Extensions\n');
  print('${'Category'.padRight(15)} ${'Plugin'.padRight(28)} ${'Type'.padRight(10)} ${'Status'.padRight(10)} Path');
  print('-' * 110);

  config.forEach((category, data) {
    if (data is! YamlMap || !data.containsKey('providers')) return;

    final providers = data['providers'] as YamlList;
    for (final provider in providers) {
      final name = (provider['name'] ?? 'unknown').toString();
      final enabled = provider['enabled'] == true;
      final path = (provider['path'] ?? 'N/A').toString();
      final status = enabled ? 'Enabled' : 'Disabled';
      final type = _providerType(provider);

      if (typeFilter != 'all' && type != typeFilter) {
        continue;
      }

      print('${category.toString().padRight(15)} ${name.padRight(28)} ${type.padRight(10)} ${status.padRight(10)} $path');
    }
  });

  print('');
}

Future<void> _enablePlugin(ArgResults results) async {
  if (results.rest.isEmpty) {
    print('Error: Plugin name required');
    print('Usage: dart bin/ds_cli.dart enable-plugin <name>');
    exit(1);
  }

  await _setPluginStatus(results.rest[0], true);
}

Future<void> _disablePlugin(ArgResults results) async {
  if (results.rest.isEmpty) {
    print('Error: Plugin name required');
    print('Usage: dart bin/ds_cli.dart disable-plugin <name>');
    exit(1);
  }

  await _setPluginStatus(results.rest[0], false);
}

Future<YamlMap> _loadConfig() async {
  final configPath = 'packages/config/registered_extensions.yaml';
  final configFile = File(configPath);

  if (!await configFile.exists()) {
    print('Config file not found: $configPath');
    exit(1);
  }

  final content = await configFile.readAsString();
  return loadYaml(content) as YamlMap;
}

Future<void> _setPluginStatus(String pluginIdentifier, bool enabled) async {
  final configPath = 'packages/config/registered_extensions.yaml';
  final configFile = File(configPath);

  if (!await configFile.exists()) {
    print('Config file not found: $configPath');
    exit(1);
  }

  final lines = await configFile.readAsLines();
  final updatedLines = <String>[];

  var found = false;
  var inTargetBlock = false;

  for (final line in lines) {
    final trimmed = line.trim();

    if (trimmed.startsWith('- name:') || trimmed.startsWith('full_name:')) {
      final value = trimmed.split(':').skip(1).join(':').trim();
      if (_isExactIdMatch(value, pluginIdentifier)) {
        inTargetBlock = true;
      } else if (trimmed.startsWith('- name:')) {
        inTargetBlock = false;
      }
    }

    if (inTargetBlock && trimmed.startsWith('enabled:')) {
      final indent = line.indexOf('enabled:');
      updatedLines.add('${' ' * indent}enabled: $enabled');
      found = true;
      inTargetBlock = false;
      continue;
    }

    updatedLines.add(line);
  }

  if (!found) {
    print('Plugin "$pluginIdentifier" not found in registry');
    exit(1);
  }

  await configFile.writeAsString(updatedLines.join('\n') + '\n');
  final status = enabled ? 'enabled' : 'disabled';
  print('Plugin "$pluginIdentifier" has been $status');
}

bool _isExactIdMatch(String yamlValue, String input) {
  final normalizedYaml = yamlValue.replaceAll('"', '').replaceAll('\'', '').trim();
  final normalizedInput = input.trim();
  return normalizedYaml == normalizedInput;
}

String _providerType(dynamic provider) {
  final explicitType = provider['type']?.toString();
  if (explicitType != null && explicitType.isNotEmpty) {
    return explicitType;
  }

  final level = provider['level']?.toString() ?? '';
  final path = provider['path']?.toString().toLowerCase() ?? '';

  if (path.contains('/enhanced/plugins/') || level == 'thirdParty') return 'plugin';
  if (level == 'core') return 'core';
  return 'provider';
}
