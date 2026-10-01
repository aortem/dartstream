import 'dart:io';

import 'package:path/path.dart' as p;

({String className, String fileName}) generatedName(String name) {
  if (!RegExp(r'^(?:[A-Z][A-Za-z0-9]*|[a-z][a-z0-9]*(?:_[a-z][a-z0-9]*)*)$')
      .hasMatch(name)) {
    throw const FormatException('Use a PascalCase or snake_case name.');
  }
  final className = name
      .split('_')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join();
  if (const {
    'String',
    'DateTime',
    'Object',
    'Map',
    'List',
    'Set',
    'Null',
    'Never',
  }.contains(className)) {
    throw const FormatException('Name conflicts with a Dart core type.');
  }
  final fileName = name
      .replaceAllMapped(
        RegExp(r'([A-Z]+)([A-Z][a-z])'),
        (m) => '${m[1]}_${m[2]}',
      )
      .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]}_${m[2]}')
      .toLowerCase();
  return (className: className, fileName: fileName);
}

/// Shared model/API output boundary: preserve files and reject linked paths.
Future<File> writeGeneratedFile({
  required Directory project,
  required String output,
  required String fileName,
  required String content,
}) async {
  final root = await project.resolveSymbolicLinks();
  if (p.isAbsolute(output)) {
    throw const FormatException('Output must be relative to the project.');
  }
  final directory = p.normalize(p.join(root, output));
  if (!p.isWithin(root, directory)) {
    throw const FormatException('Output must stay inside the project.');
  }
  var current = root;
  for (final part in p.split(p.relative(directory, from: root))) {
    current = p.join(current, part);
    final type = await FileSystemEntity.type(current, followLinks: false);
    if (type != FileSystemEntityType.directory &&
        type != FileSystemEntityType.notFound) {
      throw const FileSystemException('Output contains a link or file.');
    }
    if (type == FileSystemEntityType.directory &&
        !p.equals(await Directory(current).resolveSymbolicLinks(), current)) {
      throw const FileSystemException('Output contains a linked directory.');
    }
  }
  final target = File(p.join(directory, fileName));
  if (await FileSystemEntity.type(target.path, followLinks: false) !=
      FileSystemEntityType.notFound) {
    throw const FileSystemException('Output already exists; preserved.');
  }
  await Directory(directory).create(recursive: true);
  final staging = await Directory(directory)
      .createTemp('.dartstream-generated-');
  try {
    final candidate = File(p.join(staging.path, fileName));
    await candidate.writeAsString(content);
    if (await FileSystemEntity.type(target.path, followLinks: false) !=
        FileSystemEntityType.notFound) {
      throw const FileSystemException('Output appeared; preserved.');
    }
    await candidate.rename(target.path);
  } finally {
    await staging.delete(recursive: true);
  }
  return target;
}
