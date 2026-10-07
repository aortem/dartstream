import 'dart:io';

import 'package:yaml/yaml.dart';

import 'generated_file.dart';

/// Creates a local Shelf adapter without changing configuration or dependencies.
Future<File> setupMiddleware(Directory project) async {
  final manifest = File('${project.path}/pubspec.yaml');
  if (await FileSystemEntity.type(manifest.path, followLinks: false) !=
      FileSystemEntityType.file) {
    throw const FormatException('pubspec.yaml must be a regular file.');
  }
  final metadata = loadYaml(await manifest.readAsString());
  final dependencies = metadata is Map ? metadata['dependencies'] : null;
  if (dependencies is! Map || !dependencies.containsKey('shelf')) {
    throw const FormatException(
      'Run `dart pub add shelf` before middleware setup; no files changed.',
    );
  }
  return writeGeneratedFile(
    project: project,
    output: 'lib/src/middleware',
    fileName: 'dartstream_middleware.dart',
    content: middlewareSource,
  );
}

const middlewareSource = '''
import 'package:shelf/shelf.dart';

/// Compose application-selected Shelf middleware around actual routes.
/// The first middleware is outermost; requests enter in the supplied order
/// and responses return in reverse order. Authentication, authorization and
/// error handling remain application-owned: no security policy is installed.
Handler withDartStreamMiddleware({
  required Handler handler,
  required Iterable<Middleware> middleware,
}) {
  var pipeline = const Pipeline();
  for (final layer in middleware) {
    pipeline = pipeline.addMiddleware(layer);
  }
  return pipeline.addHandler(handler);
}
''';
