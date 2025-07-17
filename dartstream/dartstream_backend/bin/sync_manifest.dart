import 'dart:io';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as p;

Future<void> main() async {
  final root = Directory.current;
  await for (var entity in root.list(recursive: true, followLinks: false)) {
    if (entity is File && p.basename(entity.path) == 'manifest.yaml') {
      final pkgDir = p.dirname(entity.path);
      final psFile = File(p.join(pkgDir, 'pubspec.yaml'));
      if (!await psFile.exists()) continue;

      final psRaw = loadYaml(await psFile.readAsString()) as YamlMap;
      final pubVersion = psRaw['version'] as String?;
      if (pubVersion == null) continue;

      final manifestFile = File(entity.path);
      final lines = await manifestFile.readAsLines();
      final updated = lines.map((line) {
        if (line.trimLeft().startsWith('version:')) {
          final indent = line.substring(0, line.indexOf('v'));
          return '${indent}version: "$pubVersion"';
        }
        return line;
      }).toList();

      await manifestFile.writeAsString(updated.join('\n'));
      print('🔄 Synced ${manifestFile.path} → version $pubVersion');
    }
  }
}
