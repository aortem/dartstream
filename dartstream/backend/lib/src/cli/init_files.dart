import 'dart:io';

import 'package:path/path.dart' as p;

/// Validate every starter destination before changing an existing project.
void writeInitFiles(
  Directory project,
  Map<String, String> files, {
  required bool force,
}) {
  final root = p.normalize(p.absolute(project.path));
  final originals = <String, List<int>?>{};
  for (final path in files.keys) {
    final target = p.normalize(p.join(root, path));
    if (!p.isWithin(root, target)) {
      throw const FileSystemException(
        'Starter output must stay in the project.',
      );
    }
    _checkParents(p.dirname(target));
    final type = FileSystemEntity.typeSync(target, followLinks: false);
    if (type != FileSystemEntityType.file &&
        type != FileSystemEntityType.notFound) {
      throw const FileSystemException(
        'Starter output contains a link or directory.',
      );
    }
    // Read only regular files that --force explicitly permits replacing.
    if (type == FileSystemEntityType.notFound || force) {
      originals[target] = type == FileSystemEntityType.file
          ? File(target).readAsBytesSync()
          : null;
    }
  }

  for (final entry in originals.entries) {
    final target = File(entry.key);
    _checkParents(target.parent.path);
    target.parent.createSync(recursive: true);
    final staging = target.parent.createTempSync('.dartstream-init-');
    try {
      final candidate = File(p.join(staging.path, p.basename(target.path)));
      candidate.writeAsStringSync(
        files[p
            .relative(target.path, from: root)
            .replaceAll(p.separator, '/')]!,
      );
      _checkParents(target.parent.path);
      final type = FileSystemEntity.typeSync(target.path, followLinks: false);
      final original = entry.value;
      if (original == null
          ? type != FileSystemEntityType.notFound
          : type != FileSystemEntityType.file ||
                !_sameBytes(original, target.readAsBytesSync())) {
        throw const FileSystemException('Starter output changed; preserved.');
      }
      candidate.renameSync(target.path);
    } finally {
      staging.deleteSync(recursive: true);
    }
  }
}

void _checkParents(String directory) {
  var current = p.normalize(p.absolute(directory));
  while (true) {
    final type = FileSystemEntity.typeSync(current, followLinks: false);
    if (type != FileSystemEntityType.notFound &&
        (type != FileSystemEntityType.directory ||
            !p.equals(
              Directory(current).resolveSymbolicLinksSync(),
              current,
            ))) {
      throw const FileSystemException('Starter path contains a link or file.');
    }
    final parent = p.dirname(current);
    if (p.equals(parent, current)) return;
    current = parent;
  }
}

bool _sameBytes(List<int> first, List<int> second) {
  if (first.length != second.length) return false;
  for (var i = 0; i < first.length; i++) {
    if (first[i] != second[i]) return false;
  }
  return true;
}
