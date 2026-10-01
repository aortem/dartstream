import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'extension_registry.dart';

/// Records local manifest metadata without loading or executing extension code.
List<Map<String, dynamic>> discoverExtensions(
  Directory project, {
  required bool register,
}) {
  final root = project.resolveSymbolicLinksSync();
  final packages = Directory(p.join(root, 'packages'));
  final found = <String, Map<String, dynamic>>{};
  if (FileSystemEntity.isLinkSync(packages.path) ||
      (packages.existsSync() &&
          !p.equals(packages.resolveSymbolicLinksSync(), packages.path))) {
    throw const FormatException(
      'The packages directory must not be a symbolic link.',
    );
  }
  if (packages.existsSync()) {
    final files =
        packages
            .listSync(recursive: true, followLinks: false)
            .whereType<File>()
            .where((f) => p.basename(f.path) == 'manifest.yaml')
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path));
    for (final file in files) {
      if (!p.isWithin(root, file.resolveSymbolicLinksSync()) ||
          !p.equals(file.parent.resolveSymbolicLinksSync(), file.parent.path)) {
        throw const FormatException(
          'Extension manifests must stay in unlinked project directories.',
        );
      }
      final data = loadYaml(file.readAsStringSync());
      if (data is! Map)
        throw FormatException('Expected a manifest mapping: ${file.path}');
      final name = data['name'];
      final version = data['version'];
      final entry = data['entry_point'];
      final dependencies = data['dependencies'] ?? <String>[];
      // Maintained engine manifests use the historical thirdParty spelling.
      final rawLevel = data['level'] ?? 'third-party';
      final level = rawLevel == 'thirdParty' ? 'third-party' : rawLevel;
      if (name is! String ||
          !RegExp(r'^[A-Za-z][A-Za-z0-9_.-]*$').hasMatch(name) ||
          version is! String ||
          !RegExp(
            r'^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(-[0-9A-Za-z.-]+)?(\+[0-9A-Za-z.-]+)?$',
          ).hasMatch(version) ||
          entry is! String ||
          entry.isEmpty ||
          p.isAbsolute(entry) ||
          dependencies is! List ||
          dependencies.any((d) => d is! String || d.isEmpty) ||
          !['core', 'extended', 'third-party'].contains(level)) {
        throw FormatException('Invalid extension metadata: ${file.path}');
      }
      final entryFile = File(p.normalize(p.join(file.parent.path, entry)));
      if (!p.isWithin(file.parent.path, entryFile.path) ||
          !entryFile.existsSync() ||
          !p.isWithin(
            file.parent.resolveSymbolicLinksSync(),
            entryFile.resolveSymbolicLinksSync(),
          )) {
        throw FormatException(
          'Entry point must be a file inside its extension: $name',
        );
      }
      if (found.containsKey(name))
        throw FormatException('Duplicate extension name: $name');
      found[name] = {
        'name': name,
        'version': version,
        'level': level,
        'entry_point': p
            .relative(entryFile.path, from: root)
            .replaceAll('\\', '/'),
        'manifest': p.relative(file.path, from: root).replaceAll('\\', '/'),
        'dependencies': List<String>.from(dependencies),
      };
    }
  }
  final discovered = found.values.toList()
    ..sort((a, b) => (a['name'] as String).compareTo(b['name'] as String));
  if (!register || discovered.isEmpty) return discovered;
  final registry = ExtensionRegistry(project);
  final state = registry.state;
  final entries = (state['extensions'] as List).cast<Map<String, dynamic>>();
  for (final candidate in discovered) {
    final index = entries.indexWhere((e) => e['name'] == candidate['name']);
    if (index < 0) {
      entries.add({...candidate, 'enabled': true});
    } else {
      entries[index] = {...entries[index], ...candidate};
    }
  }
  state['extensions'] = entries;
  registry.save();
  return discovered;
}
