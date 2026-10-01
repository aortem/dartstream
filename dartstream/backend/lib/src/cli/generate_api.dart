import 'dart:io';

import 'package:yaml/yaml.dart';

import 'generated_file.dart';

/// Creates routing only. The application supplies every handler and its policy.
Future<File> generateApi({
  required Directory project,
  required String name,
  String output = 'lib/src/api',
}) async {
  final identifier = generatedName(name);
  final manifest = File('${project.path}/pubspec.yaml');
  final metadata = await manifest.exists()
      ? loadYaml(await manifest.readAsString())
      : null;
  final dependencies = metadata is Map ? metadata['dependencies'] : null;
  if (dependencies is! Map ||
      !dependencies.containsKey('shelf') ||
      !dependencies.containsKey('shelf_router')) {
    throw const FormatException(
      'Add direct shelf and shelf_router dependencies before API generation.',
    );
  }
  final className = '${identifier.className}Api';
  return writeGeneratedFile(
    project: project,
    output: output,
    fileName: '${identifier.fileName}_api.dart',
    content:
        '''
import 'dart:async';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

typedef ${className}ItemHandler = FutureOr<Response> Function(
  Request request,
  String id,
);

/// Local routing adapter. Handlers own auth, validation and persistence.
/// Mount behind the application's authentication/authorization middleware.
class $className {
  $className({
    required Handler list,
    required Handler create,
    required ${className}ItemHandler get,
    required ${className}ItemHandler update,
    required ${className}ItemHandler delete,
  }) : _list = list,
       _create = create,
       _get = get,
       _update = update,
       _delete = delete;

  final Handler _list;
  final Handler _create;
  final ${className}ItemHandler _get;
  final ${className}ItemHandler _update;
  final ${className}ItemHandler _delete;

  Router get router => Router()
    ..get('/', _list)
    ..post('/', _create)
    ..get('/<id>', _get)
    ..put('/<id>', _update)
    ..delete('/<id>', _delete);

  Handler get handler => router.call;
}
''',
  );
}
