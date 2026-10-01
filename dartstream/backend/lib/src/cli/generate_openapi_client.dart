import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

/// Generates a small HTTP client, without loading code from the supplied spec.
/// Existing output is never replaced, including links to customer directories.
Future<Directory> generateOpenApiClient({
  required File specification,
  required Directory output,
  required String name,
}) async {
  if (!RegExp(r'^[a-z][a-z0-9]*(?:_[a-z0-9]+)*$').hasMatch(name)) {
    throw const FormatException(
      'Client name must use lowercase words or digits separated by single underscores.',
    );
  }
  final data = jsonDecode(await specification.readAsString());
  if (data is! Map<String, dynamic> ||
      data['openapi'] is! String ||
      !(data['openapi'] as String).startsWith('3.') ||
      data['paths'] is! Map<String, dynamic>) {
    throw const FormatException('Expected an OpenAPI 3 JSON paths document.');
  }
  final methods = <String>[];
  final identifiers = <String>{'close', '_send'};
  const verbs = {'get', 'post', 'put', 'patch', 'delete', 'head', 'options'};
  // Reject invalid identifiers instead of inserting upstream text into Dart.
  const reserved = {
    'assert',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'default',
    'do',
    'else',
    'enum',
    'extends',
    'false',
    'final',
    'finally',
    'for',
    'if',
    'in',
    'is',
    'new',
    'null',
    'rethrow',
    'return',
    'super',
    'switch',
    'this',
    'throw',
    'true',
    'try',
    'var',
    'void',
    'while',
    'with',
    'await',
    'yield',
    'async',
    'baseUrl',
    '_client',
    'hashCode',
    'runtimeType',
    'toString',
    'noSuchMethod',
  };
  for (final entry in (data['paths'] as Map<String, dynamic>).entries) {
    if (!entry.key.startsWith('/') || entry.value is! Map<String, dynamic>) {
      throw const FormatException('Each path must start with / and be a map.');
    }
    _validatePathTemplate(entry.key);
    final pathItem = entry.value as Map<String, dynamic>;
    if (pathItem.containsKey(r'$ref')) {
      throw const FormatException('Referenced path items are unsupported.');
    }
    for (final operation in pathItem.entries) {
      if (!verbs.contains(operation.key)) continue;
      if (operation.value is! Map<String, dynamic>) {
        throw const FormatException('HTTP operations must be maps.');
      }
      final operationData = operation.value as Map<String, dynamic>;
      final parameters = {
        ..._parameters(pathItem['parameters']),
        ..._parameters(operationData['parameters']),
      };
      final requiredQuery = parameters.values
          .where(
            (parameter) =>
                parameter['in'] == 'query' && parameter['required'] == true,
          )
          .map((parameter) => _literal(parameter['name'] as String))
          .join(', ');
      final requestBody = operationData['requestBody'];
      if (requestBody != null &&
          (requestBody is! Map<String, dynamic> ||
              requestBody.containsKey(r'$ref') ||
              (requestBody.containsKey('required') &&
                  requestBody['required'] is! bool))) {
        throw const FormatException(
          'Request bodies must be inline objects with a boolean required flag.',
        );
      }
      final bodyRequired =
          requestBody is Map && requestBody['required'] == true;
      final id = operationData['operationId'];
      if (id is! String ||
          !RegExp(r'^[a-z][A-Za-z0-9]*$').hasMatch(id) ||
          reserved.contains(id) ||
          !identifiers.add(id)) {
        throw const FormatException('Unique valid operationId is required.');
      }
      methods.add('''
  Future<http.Response> $id({
    Map<String, String> pathParameters = const {},
    Map<String, String> query = const {},
    Map<String, String> headers = const {},
    Object? body,
  }) => _send(${_literal(operation.key.toUpperCase())}, ${_literal(entry.key)},
      pathParameters: pathParameters, query: query, headers: headers, body: body,
      requiredQuery: const [$requiredQuery], bodyRequired: $bodyRequired);
''');
    }
  }
  if (methods.isEmpty) {
    throw const FormatException('The spec has no supported HTTP operations.');
  }
  final package = 'ds_${name}_client';
  final className =
      'DS${name.split('_').map((s) => s[0].toUpperCase() + s.substring(1)).join()}Client';
  final destination = Directory(p.join(output.path, package));
  await _rejectLinks(output.path);
  if (await FileSystemEntity.type(destination.path, followLinks: false) !=
      FileSystemEntityType.notFound) {
    throw const FileSystemException('Client output already exists; preserved.');
  }
  await output.create(recursive: true);
  final staging = await output.createTemp('.dartstream-client-');
  try {
    await File(p.join(staging.path, 'pubspec.yaml')).writeAsString('''
name: $package
description: HTTP client generated from an OpenAPI 3 JSON document.
version: 0.0.1
publish_to: none
environment:
  sdk: ^3.12.2
dependencies:
  http: ^1.2.0
''');
    await Directory(p.join(staging.path, 'lib')).create();
    await File(p.join(staging.path, 'lib', '$package.dart')).writeAsString('''
import 'dart:convert';
import 'package:http/http.dart' as http;

class $className {
  $className({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client() {
    if (!{'https', 'http'}.contains(baseUrl.scheme) || baseUrl.host.isEmpty ||
        baseUrl.userInfo.isNotEmpty || baseUrl.hasQuery || baseUrl.hasFragment) {
      throw ArgumentError('Expected an HTTP(S) base URL without credentials, query or fragment.');
    }
  }
  final Uri baseUrl;
  final http.Client _client;
${methods.join()}
  Future<http.Response> _send(String method, String template, {
    required Map<String, String> pathParameters,
    required Map<String, String> query,
    required Map<String, String> headers,
    Object? body,
    required List<String> requiredQuery,
    required bool bodyRequired,
  }) async {
    if (requiredQuery.any((name) => !query.containsKey(name))) {
      throw ArgumentError('Missing required query parameter.');
    }
    if (bodyRequired && body == null) {
      throw ArgumentError('Missing required request body.');
    }
    final path = template.replaceAllMapped(RegExp(r'[{]([^{}]+)[}]'), (match) {
      final value = pathParameters[match[1]];
      if (value == null || value.isEmpty) {
        throw ArgumentError('Missing required path parameter.');
      }
      if (value == '.' || value == '..') {
        throw ArgumentError('Path parameters cannot be dot segments.');
      }
      return Uri.encodeComponent(value);
    });
    final prefix = baseUrl.toString().replaceFirst(RegExp(r'/\$'), '');
    final uri = Uri.parse(prefix + path).replace(
        queryParameters: query.isEmpty ? null : query);
    final request = http.Request(method, uri)
      ..followRedirects = false
      ..headers.addAll(headers);
    if (body != null) {
      request.headers['content-type'] = 'application/json';
      request.body = jsonEncode(body);
    }
    return http.Response.fromStream(await _client.send(request));
  }
  void close() => _client.close();
}
''');
    await File(p.join(staging.path, 'README.md')).writeAsString('''
# $className

Generated HTTP operations accept pathParameters, query, headers and a JSON body.
Path parameters must be nonempty and cannot be . or .. URI dot segments.
Pass an explicit baseUrl and a short-lived Authorization header when required.
The generator does not embed credentials, execute the spec, provision services,
or infer authentication. Responses retain their HTTP status and body, including
authorization errors. Call close() when finished.

This limited generator handles OpenAPI 3 JSON operations with unique Dart
operationId names. It does not resolve references, create typed schema models,
apply defaults, or validate schemas or header/cookie requirements. Required inline
query parameters and request bodies are checked for presence before transport;
operation parameters override matching path parameters by name and location.
Parameter and request-body references must be inlined before generation. Keep the source spec and
validate the generated package with dart pub get and dart analyze before use.
Paths cannot contain query/fragment delimiters, dot segments or malformed
placeholders. Encode literal punctuation in the spec path and pass query values
through the generated operation's query argument.
Output is never overwritten; use a new directory when regenerating.
''');
    // Recheck destination/parents before publishing the complete package.
    await _rejectLinks(output.path);
    if (await FileSystemEntity.type(destination.path, followLinks: false) !=
        FileSystemEntityType.notFound) {
      throw const FileSystemException(
        'Client output changed during generation.',
      );
    }
    return await staging.rename(destination.path);
  } finally {
    if (await staging.exists()) await staging.delete(recursive: true);
  }
}

/// OpenAPI parameter identity is (name, location); operations override paths.
Map<(String, String), Map<String, dynamic>> _parameters(Object? value) {
  if (value == null) return {};
  if (value is! List) {
    throw const FormatException('Parameters must be a list of inline objects.');
  }
  final result = <(String, String), Map<String, dynamic>>{};
  for (final parameter in value) {
    if (parameter is! Map<String, dynamic> ||
        parameter.containsKey(r'$ref') ||
        parameter['name'] is! String ||
        (parameter['name'] as String).isEmpty ||
        !['query', 'header', 'path', 'cookie'].contains(parameter['in']) ||
        (parameter.containsKey('required') && parameter['required'] is! bool)) {
      throw const FormatException(
        'Parameters require an inline name/location and boolean required flag.',
      );
    }
    final key = (parameter['name'] as String, parameter['in'] as String);
    if (result.containsKey(key)) {
      throw const FormatException('Duplicate parameter name and location.');
    }
    result[key] = parameter;
  }
  return result;
}

String _literal(String value) => jsonEncode(value).replaceAll(r'$', r'\$');

/// Validate before writing: URI normalization must not change the spec route.
void _validatePathTemplate(String path) {
  final staticPath = path.replaceAll(RegExp(r'[{][^{}]+[}]'), 'parameter');
  if (path.contains(r'\') ||
      path.contains('?') ||
      path.contains('#') ||
      staticPath.contains('{') ||
      staticPath.contains('}')) {
    throw const FormatException(
      'Paths must not contain query/fragment delimiters or malformed placeholders.',
    );
  }
  for (final segment in staticPath.split('/')) {
    final String decoded;
    try {
      decoded = Uri.decodeComponent(segment);
    } on ArgumentError {
      throw const FormatException('Paths must use valid URI percent encoding.');
    }
    if (decoded == '.' || decoded == '..') {
      throw const FormatException('Paths must not contain URI dot segments.');
    }
  }
}

Future<void> _rejectLinks(String path) async {
  var current = p.absolute(path);
  while (true) {
    final type = await FileSystemEntity.type(current, followLinks: false);
    if (type == FileSystemEntityType.link ||
        type == FileSystemEntityType.file) {
      throw const FileSystemException(
        'Client output must use regular directories.',
      );
    }
    final parent = p.dirname(current);
    if (parent == current) break;
    current = parent;
  }
}
