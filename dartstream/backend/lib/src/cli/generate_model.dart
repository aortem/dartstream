import 'dart:io';

import 'generated_file.dart';

/// Generates the documented local identity model without changing customer files.
Future<File> generateModel({
  required Directory project,
  required String name,
  String output = 'lib/src/models',
}) async {
  final identifier = generatedName(name);
  return writeGeneratedFile(
    project: project,
    output: output,
    fileName: '${identifier.fileName}.dart',
    content: modelSource(identifier.className),
  );
}

String modelSource(String className) =>
    '''
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
''';
