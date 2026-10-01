import 'dart:io';

import 'generate_api.dart';
import 'generate_model.dart';
import 'generated_file.dart';

/// A private CRUD routing package; application handlers own policy and storage.
Future<Directory> generateScaffold({
  required Directory project,
  required String name,
  String output = 'packages',
}) async {
  final identifier = generatedName(name);
  final packageName = 'ds_${identifier.fileName}_scaffold';
  return writeGeneratedPackage(
    project: project,
    output: output,
    packageName: packageName,
    files: {
      'pubspec.yaml':
          '''
name: $packageName
description: Local ${identifier.className} CRUD routing for DartStream.
version: 0.0.1
publish_to: none
environment:
  sdk: ^3.12.2
dependencies:
  shelf: ^1.4.2
  shelf_router: ^1.1.4
''',
      'lib/$packageName.dart':
          '''
export 'src/${identifier.fileName}.dart';
export 'src/${identifier.fileName}_api.dart';
''',
      'lib/src/${identifier.fileName}.dart': modelSource(identifier.className),
      'lib/src/${identifier.fileName}_api.dart': apiSource(
        '${identifier.className}Api',
      ),
      'README.md':
          '''
# ${identifier.className} CRUD routing

Run `dart pub get` in this directory. Add this private package as an explicit
path dependency to your application, then import
`package:$packageName/$packageName.dart`.

`${identifier.className}` provides id, name and creation/update timestamps with
JSON conversion and equality by id. `${identifier.className}Api` requires five
handlers: list, create, get, update and delete. Mount its `handler` behind your
application's authentication and authorization middleware. Handlers own input
validation, persistence and responses, including errors and access denials.

Routes are GET/POST `/` and GET/PUT/DELETE `/<id>`, relative to your mount point.
Generation does not install dependencies, register a route, start a server,
create a database, or configure a deployment. This package has no persistence
or authorization defaults. Supply the application's actual handlers before use.
''',
    },
  );
}
