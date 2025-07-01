// dartstream_backend/bin/generate_registry.dart

import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

Future<void> main() async {
  final now = DateTime.now().toIso8601String();
  final registryPath = 'dartstream_registry.yaml';
  final registryFile = File(registryPath);

  // 1) Read existing header (up through 'extensions:') if present
  String header;
  if (await registryFile.exists()) {
    final lines = await registryFile.readAsLines();
    final extIndex = lines.indexWhere((l) => l.trim() == 'extensions:');
    if (extIndex >= 0) {
      header = lines.sublist(0, extIndex + 1).join('\n') + '\n';
    } else {
      header = lines.join('\n') + '\nextensions:\n';
    }
  } else {
    header =
        '''
## The Manifest highlights the features and packages that are supported by the framework.
## To register your own extensions, you'll need to add them to the list.
## We support "Core" and "thirdParty" Packages.
## Core packages have first class framework support.  Third Party packages are added as a convenience, however first class suppot is not guaranted.

lastUpdated: "$now"

extensions:
''';
  }

  // 2) Find and parse all manifest.yaml files
  final buffer = StringBuffer()..write(header);
  final root = Directory.current;

  await for (final entity in root.list(recursive: true, followLinks: false)) {
    if (entity is File && p.basename(entity.path) == 'manifest.yaml') {
      final pkgDir = p.dirname(entity.path);
      final manifestRaw = loadYaml(await entity.readAsString());
      if (manifestRaw is! YamlMap) continue;
      final manifest = manifestRaw;

      final pkgName = manifest['name'] as String;
      final displayName = manifest['display_name'] as String? ?? pkgName;
      var version = manifest['version'] as String? ?? 'unspecified';
      var description = manifest['description'] as String? ?? '';
      final entryPoint =
          manifest['entry_point'] as String? ?? 'lib/$pkgName.dart';
      final level = manifest['level'] as String? ?? 'thirdParty';
      final deps =
          (manifest['dependencies'] as List?)?.cast<String>() ?? <String>[];

      // Override from pubspec.yaml if available
      final psFile = File(p.join(pkgDir, 'pubspec.yaml'));
      if (await psFile.exists()) {
        final psRaw = loadYaml(await psFile.readAsString());
        if (psRaw is YamlMap) {
          if (psRaw['version'] is String) version = psRaw['version'] as String;
          if (psRaw['description'] is String)
            description = psRaw['description'] as String;
        }
      }

      // Emit this extension entry
      buffer
        ..writeln('\n  - name: $pkgName')
        ..writeln('    display_name: $displayName')
        ..writeln('    version: $version')
        ..writeln("    description: '${description.replaceAll("'", "\\'")}'")
        ..writeln('    dependencies:');
      for (final d in deps) {
        buffer.writeln('      - $d');
      }
      buffer
        ..writeln("    entry_point: '$entryPoint'")
        ..writeln('    level: $level');
    }
  }

  // 3) Write back the registry
  await registryFile.writeAsString(buffer.toString());
  print('✅ Updated registry at $registryPath');
}
