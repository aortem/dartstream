// backend/bin/generate_registry.dart

import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

Future<void> main() async {
  final now = DateTime.now().toIso8601String();
  final registryPath = 'dartstream_registry.yaml';
  final registryFile = File(registryPath);

  final header = '''
## The Manifest highlights the features and packages that are supported by the framework.
## To register your own extensions, you'll need to add them to the list.
## We support "Core" and "thirdParty" Packages.
## Core packages have first class framework support. Third Party packages are added as a convenience.

lastUpdated: "$now"

extensions:
''';

  final buffer = StringBuffer()..write(header);
  final root = Directory.current;

  await for (final entity in root.list(recursive: true, followLinks: false)) {
    if (entity is! File || p.basename(entity.path) != 'manifest.yaml') continue;

    final manifestRaw = loadYaml(await entity.readAsString());
    if (manifestRaw is! YamlMap) continue;
    final manifest = manifestRaw;

    final pkgDir = p.dirname(entity.path);
    final relPath = p.relative(pkgDir, from: root.path).replaceAll('\\', '/');

    final pkgName = (manifest['name'] as String?)?.trim() ?? '';
    if (pkgName.isEmpty) continue;

    final displayName = manifest['display_name'] as String? ?? pkgName;
    var version = manifest['version'] as String? ?? 'unspecified';
    var description = manifest['description'] as String? ?? '';

    final entryPoint = manifest['entry_point'] as String? ?? 'lib/$pkgName.dart';

    final levelFromManifest = manifest['level'] as String?;
    final typeFromManifest = manifest['type'] as String?;
    final level = levelFromManifest ?? _levelFromType(typeFromManifest);
    final type = typeFromManifest ?? _typeFromLevel(level);

    final optional = _asBool(manifest['optional'], defaultValue: false);
    final compatible = _asBool(manifest['compatible'], defaultValue: true);
    final compatibleWith = _parseCompatibleWith(manifest['compatible_with']);

    final deps = (manifest['dependencies'] as List?)?.map((e) => '$e').toList() ?? <String>[];

    final psFile = File(p.join(pkgDir, 'pubspec.yaml'));
    if (await psFile.exists()) {
      final psRaw = loadYaml(await psFile.readAsString());
      if (psRaw is YamlMap) {
        if (psRaw['version'] is String) version = psRaw['version'] as String;
        if (psRaw['description'] is String) description = psRaw['description'] as String;
      }
    }

    final safeDescription = description.replaceAll("'", "\\'");

    buffer
      ..writeln('')
      ..writeln('  - name: $pkgName')
      ..writeln('    display_name: $displayName')
      ..writeln('    version: $version')
      ..writeln("    description: '$safeDescription'")
      ..writeln('    path: $relPath')
      ..writeln('    dependencies:');

    for (final dep in deps) {
      buffer.writeln('      - $dep');
    }

    buffer
      ..writeln("    entry_point: '$entryPoint'")
      ..writeln('    level: $level')
      ..writeln('    type: $type')
      ..writeln('    optional: $optional')
      ..writeln('    compatible: $compatible')
      ..writeln('    compatible_with:');

    if (compatibleWith.isEmpty) {
      buffer.writeln('      - dart: ">=3.0.0 <4.0.0"');
    } else {
      for (final row in compatibleWith) {
        buffer.writeln('      - $row');
      }
    }
  }

  await registryFile.writeAsString(buffer.toString());
  print('Updated registry at $registryPath');
}

bool _asBool(Object? raw, {required bool defaultValue}) {
  if (raw is bool) return raw;
  if (raw is String) {
    final v = raw.trim().toLowerCase();
    if (v == 'true') return true;
    if (v == 'false') return false;
  }
  return defaultValue;
}

String _levelFromType(String? type) {
  switch ((type ?? '').toLowerCase()) {
    case 'core':
      return 'core';
    case 'plugin':
    case 'provider':
      return 'thirdParty';
    default:
      return 'thirdParty';
  }
}

String _typeFromLevel(String? level) {
  switch ((level ?? '').toLowerCase()) {
    case 'core':
      return 'core';
    default:
      return 'plugin';
  }
}

List<String> _parseCompatibleWith(Object? raw) {
  if (raw is YamlList) {
    return raw.map((e) {
      if (e is YamlMap && e.isNotEmpty) {
        final key = e.keys.first.toString();
        final value = e.values.first.toString();
        return '$key: "$value"';
      }
      return e.toString();
    }).toList();
  }

  if (raw is YamlMap) {
    return raw.entries.map((e) => '${e.key}: "${e.value}"').toList();
  }

  return <String>[];
}
