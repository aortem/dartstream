import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';

CommandRunner<void> createDartStreamCommandRunner({
  Directory? workingDirectory,
  Directory? loginConfigDirectory,
}) {
  final cwd = workingDirectory ?? Directory.current;
  return CommandRunner<void>(
      'dartstream',
      'DartStream CLI - Full-stack framework for Dart',
    )
    ..addCommand(DSInitCommand(workingDirectory: cwd))
    ..addCommand(DSConfigureCommand(workingDirectory: cwd))
    ..addCommand(DSSetupCommand(workingDirectory: cwd))
    ..addCommand(DSGenerateCommand(workingDirectory: cwd))
    ..addCommand(DSValidateCommand(workingDirectory: cwd))
    ..addCommand(DSExtensionsCommand(workingDirectory: cwd))
    ..addCommand(DSDiscoveryCommand(workingDirectory: cwd))
    ..addCommand(DSListCommand())
    ..addCommand(DSEnableExtensionCommand(workingDirectory: cwd))
    ..addCommand(DSDisableExtensionCommand(workingDirectory: cwd))
    ..addCommand(DSLoginCommand(configDirectory: loginConfigDirectory));
}

class DSInitCommand extends Command<void> {
  DSInitCommand({required this.workingDirectory}) {
    argParser
      ..addOption(
        'name',
        abbr: 'n',
        help: 'Project name. Defaults to the target directory name.',
      )
      ..addOption(
        'directory',
        abbr: 'd',
        help: 'Directory to initialize. Defaults to the current directory.',
      )
      ..addOption(
        'version',
        abbr: 'v',
        defaultsTo: 'stable',
        allowed: ['stable', 'beta'],
        help: 'Framework version channel.',
      )
      ..addOption(
        'type',
        abbr: 't',
        defaultsTo: 'new',
        allowed: [
          'new',
          'existing-dartstream',
          'migrate-vue',
          'migrate-svelte',
          'migrate-flutter-web',
          'migrate-flutter-mobile',
          'migrate-dart-web',
        ],
        help: 'Project type.',
      )
      ..addFlag(
        'force',
        abbr: 'f',
        negatable: false,
        help: 'Overwrite generated DartStream starter files.',
      );
  }

  final Directory workingDirectory;

  @override
  final name = 'init';

  @override
  final description = 'Initialize a new DartStream project.';

  @override
  Future<void> run() async {
    final target = _targetDirectory();
    final projectName = _projectName(target);
    final force = argResults?['force'] as bool? ?? false;

    await target.create(recursive: true);
    await _writeIfMissing(File(_join(target.path, 'pubspec.yaml')), '''
name: ${_pubPackageName(projectName)}
description: A DartStream application.
version: 0.0.1

environment:
  sdk: ^3.12.2

dependencies:
  ds_dartstream: ^0.0.8
''', force: force);
    await Directory(_join(target.path, 'lib')).create(recursive: true);
    await _writeIfMissing(File(_join(target.path, 'lib', 'main.dart')), '''
void main() {
  print('DartStream project ready.');
}
''', force: force);
    await _writeIfMissing(File(_join(target.path, 'dartstream.yaml')), '''
name: $projectName
type: ${argResults?['type']}
version_channel: ${argResults?['version']}
cloud:
  vendor: local
auth:
  provider: firebase
database:
  provider: postgres
cicd:
  provider: gitlab
features: []
extensions: []
''', force: force);

    stdout.writeln(
      'DartStream project $projectName initialized with '
      '${argResults?['version']} configuration.',
    );
  }

  Directory _targetDirectory() {
    final directory = argResults?['directory'] as String?;
    if (directory == null || directory.trim().isEmpty) {
      return workingDirectory;
    }
    return Directory(_resolvePath(workingDirectory, directory.trim()));
  }

  String _projectName(Directory target) {
    final nameOption = argResults?['name'] as String?;
    if (nameOption != null && nameOption.trim().isNotEmpty) {
      return nameOption.trim();
    }
    return _basename(target.path).isEmpty
        ? 'dartstream_app'
        : _basename(target.path);
  }
}

class DSConfigureCommand extends Command<void> {
  DSConfigureCommand({required this.workingDirectory}) {
    argParser
      ..addOption('name', abbr: 'n', help: 'Project name.')
      ..addOption(
        'vendor',
        defaultsTo: 'local',
        allowed: ['gcp', 'aws', 'azure', 'local'],
        help: 'Cloud vendor.',
      )
      ..addOption(
        'auth',
        defaultsTo: 'firebase',
        help: 'Authentication provider.',
      )
      ..addOption(
        'database',
        defaultsTo: 'postgres',
        help: 'Database provider.',
      )
      ..addOption(
        'cicd',
        defaultsTo: 'gitlab',
        allowed: ['github', 'gitlab', 'custom', 'none'],
        help: 'CI/CD provider.',
      )
      ..addFlag(
        'cloud-features',
        defaultsTo: false,
        help: 'Enable cloud-only features.',
      )
      ..addFlag(
        'skip-examples',
        defaultsTo: false,
        help: 'Skip generated example configuration.',
      );
  }

  final Directory workingDirectory;

  @override
  final name = 'configure';

  @override
  final description =
      'Configure cloud vendor, authentication, database, and CI/CD for a project.';

  @override
  Future<void> run() async {
    final projectName =
        _stringOption('name') ?? _basename(workingDirectory.path);
    final file = File(_join(workingDirectory.path, 'dartstream.yaml'));
    await file.writeAsString('''
name: ${projectName.isEmpty ? 'dartstream_app' : projectName}
cloud:
  vendor: ${argResults?['vendor']}
auth:
  provider: ${argResults?['auth']}
database:
  provider: ${argResults?['database']}
cicd:
  provider: ${argResults?['cicd']}
cloud_features: ${argResults?['cloud-features']}
examples: ${!(argResults?['skip-examples'] as bool? ?? false)}
''');
    stdout.writeln('Configuration updated at ${file.path}.');
  }
}

class DSSetupCommand extends Command<void> {
  DSSetupCommand({required this.workingDirectory}) {
    argParser
      ..addOption('name', abbr: 'n', help: 'Project name.')
      ..addMultiOption(
        'features',
        abbr: 'f',
        allowed: ['security', 'performance', 'ai', 'gaming', 'analytics'],
        help: 'Advanced features to enable.',
      )
      ..addFlag(
        'saas',
        defaultsTo: false,
        help: 'Enable SaaS-aware configuration.',
      );
  }

  final Directory workingDirectory;

  @override
  final name = 'setup';

  @override
  final description = 'Set up middleware, CI/CD, and additional tools.';

  @override
  Future<void> run() async {
    final features =
        argResults?['features'] as List<String>? ?? const <String>[];
    final setupFile = File(
      _join(workingDirectory.path, '.dartstream', 'setup.json'),
    );
    await setupFile.parent.create(recursive: true);
    await setupFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert({
        'name': _stringOption('name') ?? _basename(workingDirectory.path),
        'saas': argResults?['saas'] as bool? ?? false,
        'features': features,
      }),
    );
    stdout.writeln('DartStream setup updated at ${setupFile.path}.');
  }
}

class DSGenerateCommand extends Command<void> {
  DSGenerateCommand({required this.workingDirectory}) {
    argParser
      ..addOption(
        'type',
        abbr: 't',
        allowed: [
          'model',
          'api',
          'provider',
          'extension',
          'scaffold',
          'client',
        ],
        help: 'Type of code to generate.',
      )
      ..addOption('name', abbr: 'n', help: 'Name for generated code.')
      ..addOption('project', abbr: 'p', help: 'Project to generate code for.')
      ..addOption('spec', help: 'OpenAPI JSON file for --type client.')
      ..addOption('output', help: 'Output directory for generated files.');
  }

  final Directory workingDirectory;

  @override
  final name = 'generate';

  @override
  final description = 'Generate project files based on the configuration.';

  @override
  Future<void> run() async {
    final type = _stringOption('type');
    final name = _stringOption('name') ?? 'sample';
    if (type == null || type.isEmpty) {
      throw UsageException('Missing --type.', usage);
    }

    if (type == 'client') {
      await _generateClient(name);
      return;
    }

    final output = Directory(
      _resolvePath(
        workingDirectory,
        _stringOption('output') ?? 'lib/generated',
      ),
    );
    await output.create(recursive: true);
    final file = File(_join(output.path, '${_snakeCase(name)}_$type.dart'));
    await file.writeAsString('''
// Generated by dartstream generate.

class ${_pascalCase(name)}${_pascalCase(type)} {}
''');
    stdout.writeln('Generated ${file.path}.');
  }

  Future<void> _generateClient(String name) async {
    final specPath = _stringOption('spec');
    if (specPath == null || specPath.isEmpty) {
      throw UsageException('Missing --spec for client generation.', usage);
    }

    final specFile = File(_resolvePath(workingDirectory, specPath));
    final spec =
        jsonDecode(await specFile.readAsString()) as Map<String, dynamic>;
    final output = Directory(
      _resolvePath(
        workingDirectory,
        _stringOption('output') ?? 'generated_clients',
      ),
    );
    final packageName = 'ds_${_snakeCase(name)}_client';
    final packageDir = Directory(_join(output.path, packageName));
    await Directory(
      _join(packageDir.path, 'lib', 'src'),
    ).create(recursive: true);
    await Directory(_join(packageDir.path, 'test')).create(recursive: true);

    final className = 'DS${_pascalCase(name)}Client';
    final operations = _operationsFromSpec(spec);
    final methods = operations
        .map((operation) {
          return '''
  Future<DSClientResponse> ${operation.name}() async {
    return DSClientResponse('${operation.method}', '${operation.path}');
  }
''';
        })
        .join('\n');

    await File(_join(packageDir.path, 'pubspec.yaml')).writeAsString('''
name: $packageName
description: Generated DartStream client for ${_pascalCase(name)}.
version: 0.0.1

environment:
  sdk: ^3.12.2
''');
    await File(
      _join(packageDir.path, 'lib', packageName + '.dart'),
    ).writeAsString("export 'src/${_snakeCase(name)}_client.dart';\n");
    await File(
      _join(packageDir.path, 'lib', 'src', '${_snakeCase(name)}_client.dart'),
    ).writeAsString('''
class DSClientResponse {
  const DSClientResponse(this.method, this.path);

  final String method;
  final String path;
}

class $className {
$methods
}
''');
    await File(
      _join(packageDir.path, 'test', '${_snakeCase(name)}_client_test.dart'),
    ).writeAsString('''
import 'package:$packageName/$packageName.dart';

void main() {
  $className();
}
''');
    stdout.writeln('Generated client package at ${packageDir.path}.');
  }
}

class DSValidateCommand extends Command<void> {
  DSValidateCommand({required this.workingDirectory}) {
    argParser
      ..addOption('project', abbr: 'p', help: 'Project to validate.')
      ..addOption(
        'level',
        abbr: 'l',
        allowed: ['core', 'extended', 'third-party', 'all'],
        defaultsTo: 'all',
        help: 'Validation scope.',
      )
      ..addFlag(
        'strict',
        abbr: 's',
        negatable: false,
        help: 'Fail when expected DartStream files are missing.',
      )
      ..addFlag(
        'providers',
        defaultsTo: true,
        help: 'Validate provider configuration.',
      )
      ..addFlag(
        'prefix-check',
        negatable: false,
        help: 'Validate generated naming prefixes.',
      );
  }

  final Directory workingDirectory;

  @override
  final name = 'validate';

  @override
  final description =
      'Validates project configuration and generated DartStream files.';

  @override
  Future<void> run() async {
    final missing = <String>[];
    for (final relative in ['pubspec.yaml', 'dartstream.yaml']) {
      if (!File(_join(workingDirectory.path, relative)).existsSync()) {
        missing.add(relative);
      }
    }

    if (missing.isEmpty) {
      stdout.writeln('DartStream project validation passed.');
      return;
    }

    stdout.writeln(
      'DartStream validation found missing files: ${missing.join(', ')}.',
    );
    if (argResults?['strict'] == true) {
      throw UsageException(
        'Missing required DartStream files: ${missing.join(', ')}.',
        usage,
      );
    }
  }
}

class DSExtensionsCommand extends Command<void> {
  DSExtensionsCommand({required this.workingDirectory}) {
    argParser
      ..addOption(
        'level',
        abbr: 'l',
        allowed: ['core', 'extended', 'third-party', 'all'],
        defaultsTo: 'all',
        help: 'Filter by extension level.',
      )
      ..addFlag('inactive', abbr: 'i', negatable: false)
      ..addFlag('json', abbr: 'j', negatable: false);
  }

  final Directory workingDirectory;

  @override
  final name = 'extensions';

  @override
  final description = 'Lists all discovered and registered extensions.';

  @override
  Future<void> run() async {
    final state = await _readExtensionState(workingDirectory);
    if (argResults?['json'] == true) {
      stdout.writeln(const JsonEncoder.withIndent('  ').convert(state));
      return;
    }
    stdout.writeln('Registered Extensions:');
    final extensions = state['extensions'] as List<dynamic>;
    if (extensions.isEmpty) {
      stdout.writeln('No extensions discovered or registered.');
      return;
    }
    for (final extension in extensions.cast<Map<String, dynamic>>()) {
      stdout.writeln(
        '- ${extension['name']} (${extension['enabled'] == true ? 'enabled' : 'disabled'})',
      );
    }
    stdout.writeln('Total: ${extensions.length}');
  }
}

class DSDiscoveryCommand extends Command<void> {
  DSDiscoveryCommand({required this.workingDirectory}) {
    argParser
      ..addOption('project', abbr: 'p', help: 'Project name.')
      ..addFlag('register', abbr: 'r', defaultsTo: true)
      ..addFlag('validate', abbr: 'v', defaultsTo: true);
  }

  final Directory workingDirectory;

  @override
  final name = 'discover';

  @override
  final description = 'Discovers and registers DartStream extensions.';

  @override
  Future<void> run() async {
    stdout.writeln('Starting extension discovery...');
    final candidates = <String>{};
    final packagesDir = Directory(_join(workingDirectory.path, 'packages'));
    if (packagesDir.existsSync()) {
      for (final entity in packagesDir.listSync(recursive: true)) {
        if (entity is File && _basename(entity.path) == 'pubspec.yaml') {
          candidates.add(_basename(Directory(entity.parent.path).path));
        }
      }
    }

    if (argResults?['register'] == true) {
      final state = {
        'extensions': [
          for (final name in candidates) {'name': name, 'enabled': true},
        ],
      };
      await _writeExtensionState(workingDirectory, state);
    }

    stdout.writeln(
      'Discovery complete. Registered extensions: ${candidates.length}.',
    );
  }
}

class DSEnableExtensionCommand extends Command<void> {
  DSEnableExtensionCommand({required this.workingDirectory}) {
    argParser.addOption(
      'level',
      abbr: 'l',
      allowed: ['core', 'extended', 'third-party'],
      defaultsTo: 'third-party',
      help: 'Extension level.',
    );
  }

  final Directory workingDirectory;

  @override
  final name = 'enable-extension';

  @override
  final description = 'Enables a specified extension.';

  @override
  Future<void> run() async {
    await _setExtensionEnabled(workingDirectory, argResults?.rest, true);
  }
}

class DSDisableExtensionCommand extends Command<void> {
  DSDisableExtensionCommand({required this.workingDirectory}) {
    argParser.addFlag(
      'force',
      abbr: 'f',
      negatable: false,
      help: 'Force disable even if dependencies exist.',
    );
  }

  final Directory workingDirectory;

  @override
  final name = 'disable-extension';

  @override
  final description = 'Disables a specified extension.';

  @override
  Future<void> run() async {
    await _setExtensionEnabled(workingDirectory, argResults?.rest, false);
  }
}

class DSListCommand extends Command<void> {
  @override
  final name = 'list';

  @override
  final description = 'Lists all available commands for DartStream.';

  @override
  Future<void> run() async {
    stdout.writeln('Available commands:');
    for (final command in _publicCommands) {
      stdout.writeln('- ${command.name}: ${command.description}');
    }
  }
}

class DSLoginCommand extends Command<void> {
  DSLoginCommand({this.configDirectory}) {
    argParser
      ..addOption(
        'token',
        help: 'DartStream API token to save for CLI workflows.',
      )
      ..addOption(
        'api-url',
        defaultsTo: 'https://api.dartstream.io',
        help: 'DartStream API base URL.',
      );
  }

  final Directory? configDirectory;

  @override
  final name = 'login';

  @override
  final description = 'Authenticate this machine with a DartStream API token.';

  @override
  Future<void> run() async {
    final token = _tokenFromArgs();
    if (token == null || token.isEmpty) {
      throw UsageException('Missing token. Pass --token <token>.', usage);
    }

    final configDir = _resolveConfigDirectory();
    await configDir.create(recursive: true);

    final credentialsFile = File(_join(configDir.path, 'credentials.json'));
    final payload = <String, dynamic>{
      'token': token,
      'apiUrl': argResults?['api-url'] as String,
      'savedAt': DateTime.now().toUtc().toIso8601String(),
    };

    await credentialsFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(payload),
    );

    stdout.writeln('DartStream CLI login saved.');
  }

  String? _tokenFromArgs() {
    final token = argResults?['token'] as String?;
    if (token != null && token.trim().isNotEmpty) return token.trim();

    final envToken = Platform.environment['DARTSTREAM_TOKEN'];
    if (envToken != null && envToken.trim().isNotEmpty) {
      return envToken.trim();
    }

    return null;
  }

  Directory _resolveConfigDirectory() {
    if (configDirectory != null) return configDirectory!;

    final override = Platform.environment['DARTSTREAM_CONFIG_DIR'];
    if (override != null && override.trim().isNotEmpty) {
      return Directory(override.trim());
    }

    if (Platform.isWindows) {
      final appData = Platform.environment['APPDATA'];
      if (appData != null && appData.trim().isNotEmpty) {
        return Directory(_join(appData.trim(), 'DartStream'));
      }
    }

    final home =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'];
    if (home == null || home.trim().isEmpty) {
      return Directory('.dartstream');
    }

    return Directory(_join(home.trim(), '.dartstream'));
  }
}

class _PublicCommand {
  const _PublicCommand(this.name, this.description);

  final String name;
  final String description;
}

class _Operation {
  const _Operation(this.name, this.method, this.path);

  final String name;
  final String method;
  final String path;
}

const _publicCommands = [
  _PublicCommand('init', 'Initialize a new DartStream project.'),
  _PublicCommand('configure', 'Configure cloud, auth, database, and CI/CD.'),
  _PublicCommand('setup', 'Set up middleware, CI/CD, and additional tools.'),
  _PublicCommand('generate', 'Generate project files and clients.'),
  _PublicCommand('validate', 'Validate project configuration.'),
  _PublicCommand('extensions', 'List registered extensions.'),
  _PublicCommand('discover', 'Discover extensions.'),
  _PublicCommand('list', 'List commands.'),
  _PublicCommand('enable-extension', 'Enable an extension.'),
  _PublicCommand('disable-extension', 'Disable an extension.'),
  _PublicCommand('login', 'Authenticate with a DartStream API token.'),
];

extension _OptionAccess on Command<void> {
  String? _stringOption(String name) {
    final value = argResults?[name] as String?;
    if (value == null || value.trim().isEmpty) return null;
    return value.trim();
  }
}

Future<void> _writeIfMissing(
  File file,
  String content, {
  required bool force,
}) async {
  if (file.existsSync() && !force) return;
  await file.parent.create(recursive: true);
  await file.writeAsString(content);
}

String _resolvePath(Directory base, String path) {
  final normalized = path.trim();
  if (normalized.isEmpty) return base.path;
  if (RegExp(r'^[A-Za-z]:[\\/]').hasMatch(normalized) ||
      normalized.startsWith('/') ||
      normalized.startsWith(r'\\')) {
    return normalized;
  }
  return _join(base.path, normalized);
}

String _join(String first, [String? second, String? third, String? fourth]) {
  final parts = [
    first,
    if (second != null) second,
    if (third != null) third,
    if (fourth != null) fourth,
  ];
  return parts.join(Platform.pathSeparator);
}

String _basename(String path) {
  final normalized = path.replaceAll('\\', '/');
  final segments = normalized.split('/')..removeWhere((part) => part.isEmpty);
  return segments.isEmpty ? '' : segments.last;
}

String _pubPackageName(String input) {
  final name = _snakeCase(input);
  if (name.isEmpty) return 'dartstream_app';
  if (RegExp(r'^[a-z_]').hasMatch(name)) return name;
  return 'ds_$name';
}

String _snakeCase(String input) {
  return input
      .trim()
      .replaceAll(RegExp(r'[^A-Za-z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '')
      .toLowerCase();
}

String _pascalCase(String input) {
  final words = _snakeCase(input).split('_').where((word) => word.isNotEmpty);
  final result = words.map((word) {
    return word.substring(0, 1).toUpperCase() + word.substring(1);
  }).join();
  return result.isEmpty ? 'Generated' : result;
}

List<_Operation> _operationsFromSpec(Map<String, dynamic> spec) {
  final paths = spec['paths'];
  if (paths is! Map<String, dynamic>) return const [];
  final operations = <_Operation>[];
  for (final entry in paths.entries) {
    final value = entry.value;
    if (value is! Map<String, dynamic>) continue;
    for (final methodEntry in value.entries) {
      final method = methodEntry.key.toUpperCase();
      final methodValue = methodEntry.value;
      if (methodValue is! Map<String, dynamic>) continue;
      final operationId = methodValue['operationId'] as String?;
      operations.add(
        _Operation(
          operationId == null || operationId.isEmpty
              ? _operationName(method, entry.key)
              : operationId,
          method,
          entry.key,
        ),
      );
    }
  }
  return operations;
}

String _operationName(String method, String path) {
  final suffix = path
      .split('/')
      .where((part) => part.isNotEmpty)
      .map((part) => part.replaceAll(RegExp(r'[{}]'), ''))
      .map(_pascalCase)
      .join();
  return method.toLowerCase() + (suffix.isEmpty ? 'Root' : suffix);
}

Future<Map<String, dynamic>> _readExtensionState(
  Directory workingDirectory,
) async {
  final file = File(
    _join(workingDirectory.path, '.dartstream', 'extensions.json'),
  );
  if (!file.existsSync()) return {'extensions': <Map<String, dynamic>>[]};
  final data = jsonDecode(await file.readAsString());
  if (data is Map<String, dynamic>) {
    final extensions = data['extensions'];
    if (extensions is List) return {'extensions': extensions};
  }
  return {'extensions': <Map<String, dynamic>>[]};
}

Future<void> _writeExtensionState(
  Directory workingDirectory,
  Map<String, dynamic> state,
) async {
  final file = File(
    _join(workingDirectory.path, '.dartstream', 'extensions.json'),
  );
  await file.parent.create(recursive: true);
  await file.writeAsString(const JsonEncoder.withIndent('  ').convert(state));
}

Future<void> _setExtensionEnabled(
  Directory workingDirectory,
  List<String>? args,
  bool enabled,
) async {
  if (args == null || args.isEmpty) {
    throw UsageException(
      'Missing extension name.',
      'dartstream ${enabled ? 'enable-extension' : 'disable-extension'} <name>',
    );
  }

  final state = await _readExtensionState(workingDirectory);
  final extensions = (state['extensions'] as List<dynamic>)
      .whereType<Map<String, dynamic>>()
      .toList();
  final name = args.first;
  final existing = extensions.where((extension) => extension['name'] == name);
  if (existing.isEmpty) {
    extensions.add({'name': name, 'enabled': enabled});
  } else {
    existing.first['enabled'] = enabled;
  }
  await _writeExtensionState(workingDirectory, {'extensions': extensions});
  stdout.writeln('${enabled ? 'Enabled' : 'Disabled'} extension $name.');
}
