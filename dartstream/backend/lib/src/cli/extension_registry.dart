import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// Shared local registry boundary for discovery, listing and state changes.
class ExtensionRegistry {
  ExtensionRegistry(Directory project)
    : directory = Directory(
        p.join(project.resolveSymbolicLinksSync(), '.dartstream'),
      ) {
    _verifyPath();
    original = file.existsSync() ? file.readAsStringSync() : null;
    final parsed = original == null
        ? <String, dynamic>{'extensions': <dynamic>[]}
        : jsonDecode(original!);
    if (parsed is! Map<String, dynamic> || parsed['extensions'] is! List) {
      throw const FormatException(
        'Existing extension registry has an invalid shape.',
      );
    }
    final names = <String>{};
    for (final entry in parsed['extensions'] as List) {
      if (entry is! Map<String, dynamic> ||
          entry['name'] is! String ||
          (entry['name'] as String).isEmpty ||
          !names.add(entry['name'] as String) ||
          (entry.containsKey('enabled') && entry['enabled'] is! bool)) {
        throw const FormatException(
          'Registry entries must have unique names and boolean enabled states.',
        );
      }
    }
    state = parsed;
    originalState = jsonEncode(parsed);
  }

  final Directory directory;
  File get file => File(p.join(directory.path, 'extensions.json'));
  late final String? original;
  late final String originalState;
  late final Map<String, dynamic> state;

  void _verifyPath() {
    final directoryType = FileSystemEntity.typeSync(
      directory.path,
      followLinks: false,
    );
    final fileType = FileSystemEntity.typeSync(file.path, followLinks: false);
    if ((directoryType != FileSystemEntityType.notFound &&
            directoryType != FileSystemEntityType.directory) ||
        (directoryType == FileSystemEntityType.directory &&
            !p.equals(directory.resolveSymbolicLinksSync(), directory.path)) ||
        (fileType != FileSystemEntityType.notFound &&
            fileType != FileSystemEntityType.file)) {
      throw const FormatException(
        'Extension registry must use unlinked regular paths.',
      );
    }
  }

  void save() {
    if (jsonEncode(state) == originalState) return;
    _verifyPath();
    directory.createSync(recursive: true);
    final staging = directory.createTempSync('.dartstream-registry-');
    try {
      final candidate = File(p.join(staging.path, 'extensions.json'));
      candidate.writeAsStringSync(
        '${const JsonEncoder.withIndent('  ').convert(state)}\n',
        flush: true,
      );
      _verifyPath();
      if ((file.existsSync() ? file.readAsStringSync() : null) != original) {
        throw const FileSystemException(
          'Registry changed during the edit; rerun the command.',
        );
      }
      candidate.renameSync(file.path);
    } finally {
      staging.deleteSync(recursive: true);
    }
  }
}
