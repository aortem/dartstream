import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

/// Edits only explicitly requested options in an existing customer file.
Future<List<String>> configureFile(
  File file,
  Map<String, Object> options, {
  required String defaultName,
  bool force = false,
}) async {
  final type = await FileSystemEntity.type(file.path, followLinks: false);
  if (type != FileSystemEntityType.notFound &&
      type != FileSystemEntityType.file) {
    throw const FormatException('Configuration must be a regular file.');
  }
  final exists = type == FileSystemEntityType.file;
  final original = exists ? await file.readAsString() : '';
  Map<dynamic, dynamic> current = {};
  if (exists && !force) {
    final parsed = loadYaml(original);
    if (parsed != null && parsed is! YamlMap) {
      throw const FormatException('Configuration must be a YAML mapping.');
    }
    current = parsed as Map<dynamic, dynamic>? ?? {};
  }
  final values = <String, Object>{
    if (!exists || force) ...{
      'name': defaultName,
      'vendor': 'local',
      'auth': 'firebase',
      'database': 'postgres',
      'cicd': 'gitlab',
      'cloud-features': false,
      'skip-examples': false,
    },
    ...options,
  };
  const paths = <String, List<String>>{
    'name': ['name'],
    'vendor': ['cloud', 'vendor'],
    'auth': ['auth', 'provider'],
    'database': ['database', 'provider'],
    'cicd': ['cicd', 'provider'],
    'cloud-features': ['cloud_features'],
    'skip-examples': ['examples'],
  };
  final editor = YamlEditor(exists && !force ? original : '');
  if (!exists || force || loadYaml(original) == null) {
    editor.update([], <String, Object?>{});
  }
  final changes = <String>[
    if (force && exists) 'Replace dartstream.yaml (--force).',
  ];
  for (final entry in values.entries) {
    final path = paths[entry.key]!;
    final value = entry.key == 'skip-examples'
        ? !(entry.value as bool)
        : entry.value;
    final parent = path.length == 2 ? current[path.first] : current;
    if (path.length == 2 && current.containsKey(path.first) && parent is! Map) {
      throw FormatException(
        '${path.first} must be a mapping; file was preserved.',
      );
    }
    final previous = parent is Map ? parent[path.last] : null;
    if (previous == value) continue;
    if (path.length == 2 && !current.containsKey(path.first)) {
      editor.update([path.first], <String, Object>{path.last: value});
    } else {
      editor.update(path, value);
    }
    // Report affected keys without copying potentially sensitive customer values.
    changes.add('${previous == null ? '+' : '~'} ${path.join('.')}: $value');
  }
  if (changes.isEmpty) return changes;
  final updated = editor.toString();
  if (updated == original) return [];
  // Detect ordinary concurrent edits before replacing the file atomically.
  if (await FileSystemEntity.type(file.path, followLinks: false) != type ||
      exists && await file.readAsString() != original) {
    throw const FileSystemException('Configuration changed during the edit.');
  }
  final temporary = await file.parent.createTemp('.dartstream-config-');
  try {
    final candidate = File('${temporary.path}/dartstream.yaml');
    await candidate.writeAsString(updated, flush: true);
    await candidate.rename(file.path);
  } finally {
    await temporary.delete(recursive: true);
  }
  return changes;
}
