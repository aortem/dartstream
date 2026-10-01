import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

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
  final directory = Directory(p.join(root, '.dartstream'));
  final file = File(p.join(directory.path, 'extensions.json'));
  if (FileSystemEntity.isLinkSync(directory.path) ||
      FileSystemEntity.isLinkSync(file.path) ||
      (directory.existsSync() &&
          !p.equals(directory.resolveSymbolicLinksSync(), directory.path))) {
    throw const FormatException(
      'Extension registry must not be a symbolic link.',
    );
  }
  final original = file.existsSync() ? file.readAsStringSync() : null;
  final parsed = original == null
      ? <String, dynamic>{'extensions': <dynamic>[]}
      : jsonDecode(original);
  if (parsed is! Map<String, dynamic> || parsed['extensions'] is! List) {
    throw const FormatException(
      'Existing extension registry has an invalid shape.',
    );
  }
  final state = Map<String, dynamic>.from(parsed);
  final entries = <Map<String, dynamic>>[];
  final names = <String>{};
  for (final entry in parsed['extensions'] as List) {
    if (entry is! Map<String, dynamic> ||
        entry['name'] is! String ||
        !names.add(entry['name'] as String) ||
        (entry.containsKey('enabled') && entry['enabled'] is! bool)) {
      throw const FormatException(
        'Existing registry entries must have unique names and boolean enabled states.',
      );
    }
    entries.add(Map<String, dynamic>.from(entry));
  }
  for (final candidate in discovered) {
    final index = entries.indexWhere((e) => e['name'] == candidate['name']);
    if (index < 0) {
      entries.add({...candidate, 'enabled': true});
    } else {
      entries[index] = {...entries[index], ...candidate};
    }
  }
  state['extensions'] = entries;
  if (jsonEncode(state) == jsonEncode(parsed)) return discovered;
  directory.createSync(recursive: true);
  final temporary = File(
    p.join(
      directory.path,
      '.extensions-${pid}-${DateTime.now().microsecondsSinceEpoch}.tmp',
    ),
  );
  try {
    temporary.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(state)}\n',
      flush: true,
    );
    if ((file.existsSync() ? file.readAsStringSync() : null) != original) {
      throw const FileSystemException(
        'Registry changed during discovery; rerun discovery.',
      );
    }
    temporary.renameSync(file.path);
  } finally {
    if (temporary.existsSync()) temporary.deleteSync();
  }
  return discovered;
}
