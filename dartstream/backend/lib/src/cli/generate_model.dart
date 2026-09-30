import 'dart:io';

import 'package:path/path.dart' as p;

/// Generates the documented local identity model without changing customer files.
Future<File> generateModel({
  required Directory project,
  required String name,
  String output = 'lib/src/models',
}) async {
  if (!RegExp(
    r'^(?:[A-Z][A-Za-z0-9]*|[a-z][a-z0-9]*(?:_[a-z][a-z0-9]*)*)$',
  ).hasMatch(name)) {
    throw const FormatException('Use a PascalCase or snake_case model name.');
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
    throw const FormatException('Model name conflicts with a Dart core type.');
  }
  final fileName = name
      .replaceAllMapped(
        RegExp(r'([A-Z]+)([A-Z][a-z])'),
        (m) => '${m[1]}_${m[2]}',
      )
      .replaceAllMapped(RegExp(r'([a-z0-9])([A-Z])'), (m) => '${m[1]}_${m[2]}')
      .toLowerCase();
  final root = await project.resolveSymbolicLinks();
  if (p.isAbsolute(output)) {
    throw const FormatException(
      'Model output must be relative to the project.',
    );
  }
  final directory = p.normalize(p.join(root, output));
  if (!p.isWithin(root, directory)) {
    throw const FormatException('Model output must stay inside the project.');
  }
  var current = root;
  for (final part in p.split(p.relative(directory, from: root))) {
    current = p.join(current, part);
    final type = await FileSystemEntity.type(current, followLinks: false);
    if (type != FileSystemEntityType.directory &&
        type != FileSystemEntityType.notFound) {
      throw const FileSystemException('Model output contains a link or file.');
    }
    if (type == FileSystemEntityType.directory &&
        !p.equals(await Directory(current).resolveSymbolicLinks(), current)) {
      throw const FileSystemException(
        'Model output contains a linked directory.',
      );
    }
  }
  final target = File(p.join(directory, '$fileName.dart'));
  if (await FileSystemEntity.type(target.path, followLinks: false) !=
      FileSystemEntityType.notFound) {
    throw const FileSystemException('Model output already exists; preserved.');
  }
  await Directory(directory).create(recursive: true);
  final staging = await Directory(directory).createTemp('.dartstream-model-');
  try {
    final candidate = File(p.join(staging.path, '$fileName.dart'));
    await candidate.writeAsString('''
/// Local identity model. Equality follows the documented id contract.
class $className {
  const $className({
    required this.id,
    required this.name,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime? updatedAt;

  factory $className.fromJson(Map<String, dynamic> json) => $className(
    id: json['id'] as String,
    name: json['name'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null : DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'created_at': createdAt.toIso8601String(),
    if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
  };

  $className copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => $className(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is $className && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '$className(id: \$id, name: \$name)';
}
''');
    if (await FileSystemEntity.type(target.path, followLinks: false) !=
        FileSystemEntityType.notFound) {
      throw const FileSystemException('Model output appeared; preserved.');
    }
    await candidate.rename(target.path);
  } finally {
    await staging.delete(recursive: true);
  }
  return target;
}
