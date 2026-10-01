import 'dart:convert';

import 'cli_session.dart';
import 'configure_file.dart';
import 'setup_ci.dart';
import 'generate_openapi_client.dart';
import 'generate_model.dart';
import 'generate_api.dart';
import 'discover_extensions.dart';
import 'extension_registry.dart';
import 'init_files.dart';

import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:args/args.dart';

const dartStreamCliVersion = '0.0.11';

String? dartStreamCliVersionOutput(List<String> args) {
  if (args.length == 1 && (args.first == '--version' || args.first == '-v')) {
    return 'ds_dartstream $dartStreamCliVersion';
  }
  return null;
}

CommandRunner<void> createDartStreamCommandRunner({
  Directory? workingDirectory,
  Directory? loginConfigDirectory,
  CliSession? session,
}) {
  final cwd = workingDirectory ?? Directory.current;
  final auth = session ?? CliSession(directory: loginConfigDirectory);
  return CommandRunner<void>(
      'dartstream',
      'DartStream CLI - Full-stack framework for Dart',
    )
    ..addCommand(DSInitCommand(workingDirectory: cwd))
    ..addCommand(DSConfigureCommand(workingDirectory: cwd))
    ..addCommand(DSSetupCommand(workingDirectory: cwd))
    ..addCommand(DSGenerateCommand(workingDirectory: cwd))
    ..addCommand(DSValidateCommand(workingDirectory: cwd, session: auth))
    ..addCommand(DSExtensionsCommand(workingDirectory: cwd))
    ..addCommand(DSDiscoveryCommand(workingDirectory: cwd))
    ..addCommand(DSListCommand())
    ..addCommand(DSEnableExtensionCommand(workingDirectory: cwd))
    ..addCommand(DSDisableExtensionCommand(workingDirectory: cwd))
    ..addCommand(DSLoginCommand(auth));
}

/// Disables unfinished commands before they can touch customer files.
class DSComingSoonCommand extends Command<void> {
  DSComingSoonCommand(this.original) {
    _useOriginal = true;
  }
  bool _useOriginal = false;
  final Command<void> original;
  @override
  String get name => original.name;
  @override
  String get description => '${original.description} (coming soon)';
  @override
  ArgParser get argParser =>
      _useOriginal ? original.argParser : super.argParser;
  @override
  Future<void> run() async {
    throw UsageException(
      'Coming soon - see https://docs.dartstream.io/dartstream/v0.0.1/cli.html',
      usage,
    );
  }
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

    final packageName = _pubPackageName(projectName);
    final files = <String, String>{
      'pubspec.yaml':
          '''
name: ${_pubPackageName(projectName)}
description: A DartStream application.
version: 0.0.1

environment:
  sdk: ^3.12.2

dependencies:
  ds_dartstream: ^0.0.8
''',
      'lib/main.dart': '''
void main() {
  print('DartStream project ready.');
}
''',
      'bin/$packageName.dart':
          "import 'package:$packageName/main.dart' as application;\n\n"
          'void main() => application.main();\n',
      'dartstream.yaml':
          '''
name: ${jsonEncode(projectName)}
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
''',
    };
    try {
      writeInitFiles(target, files, force: force);
    } on FileSystemException catch (error) {
      throw UsageException(error.message, usage);
    }

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
      )
      ..addFlag(
        'force',
        negatable: false,
        help:
            'Replace the entire configuration with these options and defaults.',
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
    final values = <String, Object>{
      for (final name in [
        'name',
        'vendor',
        'auth',
        'database',
        'cicd',
        'cloud-features',
        'skip-examples',
      ])
        if (argResults!.wasParsed(name)) name: argResults![name] as Object,
    };
    try {
      final changes = await configureFile(
        File(_join(workingDirectory.path, 'dartstream.yaml')),
        values,
        defaultName: _basename(workingDirectory.path).isEmpty
            ? 'dartstream_app'
            : _basename(workingDirectory.path),
        force: argResults!['force'] as bool,
      );
      stdout.writeln(
        changes.isEmpty ? 'No configuration changes.' : changes.join('\n'),
      );
    } on FormatException catch (error) {
      throw UsageException(error.message, usage);
    }
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
  final description =
      'Create local GitLab validation CI; middleware/tools coming soon.';

  @override
  Future<void> run() async {
    if (_stringOption('name') != null ||
        (argResults?['saas'] as bool? ?? false) ||
        (argResults?['features'] as List<String>? ?? const <String>[])
            .isNotEmpty) {
      throw UsageException(
        'Coming soon: middleware, SaaS and advanced tool setup; no files changed.',
        usage,
      );
    }
    try {
      stdout.writeln(await setupValidationCi(workingDirectory));
    } on FormatException catch (error) {
      throw UsageException(error.message, usage);
    } on FileSystemException catch (error) {
      throw UsageException(error.message, usage);
    }
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
      ..addOption('spec', help: 'OpenAPI JSON file for --type client.')
      ..addOption('output', help: 'Output directory for generated files.');
  }

  final Directory workingDirectory;

  @override
  final name = 'generate';

  @override
  final description =
      'Generate local models, API routes or OpenAPI clients; other types coming soon.';

  @override
  Future<void> run() async {
    final type = _stringOption('type');
    final name = _stringOption('name') ?? 'sample';
    if (type == null || type.isEmpty) {
      throw UsageException('Missing --type.', usage);
    }

    if (type == 'model') {
      final modelName = _stringOption('name');
      if (modelName == null || modelName.isEmpty) {
        throw UsageException('Missing --name for model generation.', usage);
      }
      if (_stringOption('spec') != null) {
        throw UsageException('--spec is supported for clients only.', usage);
      }
      try {
        final generated = await generateModel(
          project: workingDirectory,
          name: modelName,
          output: _stringOption('output') ?? 'lib/src/models',
        );
        stdout.writeln('Generated local model at ${generated.path}.');
      } on FormatException catch (error) {
        throw UsageException(error.message, usage);
      } on FileSystemException catch (error) {
        throw UsageException(error.message, usage);
      }
      return;
    }

    if (type == 'api') {
      final apiName = _stringOption('name');
      if (apiName == null || apiName.isEmpty) {
        throw UsageException('Missing --name for API generation.', usage);
      }
      if (_stringOption('spec') != null) {
        throw UsageException('--spec is supported for clients only.', usage);
      }
      try {
        final generated = await generateApi(
          project: workingDirectory,
          name: apiName,
          output: _stringOption('output') ?? 'lib/src/api',
        );
        stdout.writeln('Generated local API routes at ${generated.path}.');
      } on FormatException catch (error) {
        throw UsageException(error.message, usage);
      } on FileSystemException catch (error) {
        throw UsageException(error.message, usage);
      }
      return;
    }

    if (type != 'client') {
      throw UsageException(
        'Coming soon - only --type model, api and client are currently supported.',
        usage,
      );
    }
    final spec = _stringOption('spec');
    if (spec == null) {
      throw UsageException('Missing --spec for client generation.', usage);
    }
    try {
      final generated = await generateOpenApiClient(
        specification: File(_resolvePath(workingDirectory, spec)),
        output: Directory(
          _resolvePath(
            workingDirectory,
            _stringOption('output') ?? 'generated_clients',
          ),
        ),
        name: name,
      );
      stdout.writeln('Generated HTTP client package at ${generated.path}.');
    } on FormatException catch (error) {
      throw UsageException(error.message, usage);
    } on FileSystemException catch (error) {
      throw UsageException(error.message, usage);
    }
  }
}

class DSValidateCommand extends Command<void> {
  DSValidateCommand({required this.workingDirectory, required this.session}) {
    argParser.addOption('env', allowed: ['prod', 'dev']);
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
  final CliSession session;

  @override
  final name = 'validate';

  @override
  final description =
      'Validates project configuration and generated DartStream files.';

  @override
  Future<void> run() async {
    final project = argResults?['project'] as String?;
    if (project != null) {
      await session.validateProject(
        project,
        env: argResults?['env'] as String?,
      );
      stdout.writeln('DartStream project validated.');
      return;
    }
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
      ..addFlag(
        'inactive',
        abbr: 'i',
        negatable: false,
        help: 'Include disabled extensions in the listing.',
      )
      ..addFlag('json', abbr: 'j', negatable: false);
  }

  final Directory workingDirectory;

  @override
  final name = 'extensions';

  @override
  final description = 'Lists all discovered and registered extensions.';

  @override
  Future<void> run() async {
    final Map<String, dynamic> state;
    try {
      state = ExtensionRegistry(workingDirectory).state;
    } on FormatException catch (error) {
      throw UsageException(error.message, usage);
    } on FileSystemException catch (error) {
      throw UsageException(error.message, usage);
    }
    final level = argResults?['level'] as String? ?? 'all';
    final includeInactive = argResults?['inactive'] == true;
    final extensions = (state['extensions'] as List<dynamic>)
        .whereType<Map<String, dynamic>>()
        .where((extension) {
          final rawLevel = extension['level'] ?? 'third-party';
          final extensionLevel = rawLevel == 'thirdParty'
              ? 'third-party'
              : rawLevel;
          return (level == 'all' || extensionLevel == level) &&
              (includeInactive || extension['enabled'] == true);
        })
        .toList();
    if (argResults?['json'] == true) {
      stdout.writeln(
        const JsonEncoder.withIndent('  ').convert({'extensions': extensions}),
      );
      return;
    }
    stdout.writeln('Registered Extensions:');
    if (extensions.isEmpty) {
      stdout.writeln('No registered extensions match the selected filters.');
      return;
    }
    for (final extension in extensions) {
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
      ..addOption(
        'project',
        abbr: 'p',
        help: 'Project directory (defaults to the current directory).',
      )
      ..addFlag('register', abbr: 'r', defaultsTo: false)
      ..addFlag('validate', abbr: 'v', defaultsTo: true);
  }

  final Directory workingDirectory;

  @override
  final name = 'discover';

  @override
  final description = 'Discovers and registers DartStream extensions.';

  @override
  Future<void> run() async {
    if (argResults?['validate'] == false) {
      throw UsageException(
        'Manifest validation is required; --no-validate is unsupported.',
        usage,
      );
    }
    final target = argResults?['project'] as String?;
    final directory = target == null
        ? workingDirectory
        : Directory(_resolvePath(workingDirectory, target));
    try {
      final discovered = discoverExtensions(
        directory,
        register: argResults?['register'] == true,
      );
      for (final extension in discovered) {
        stdout.writeln(
          '${extension['name']} ${extension['version']} ${extension['entry_point']}',
        );
      }
      stdout.writeln(
        'Discovered ${discovered.length} local extension manifests. '
        '${argResults?['register'] == true ? 'Registry updated when needed.' : 'Registry unchanged.'} '
        'Extension code was not loaded.',
      );
    } on FormatException catch (error) {
      throw UsageException(error.message, usage);
    } on FileSystemException catch (error) {
      throw UsageException(error.message, usage);
    }
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
    await _setExtensionEnabled(
      workingDirectory,
      argResults?.rest,
      false,
      force: argResults?['force'] == true,
    );
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
  DSLoginCommand(this.session) {
    argParser
      ..addOption('client-id', help: 'Client ID shown with the CLI token.')
      ..addOption('token', help: 'CLI credential secret.')
      ..addOption('env', allowed: ['prod', 'dev'], defaultsTo: 'prod');
  }
  final CliSession session;
  @override
  final name = 'login';
  @override
  final description = 'Validate and save a CLI credential.';
  @override
  Future<void> run() async {
    try {
      await session.login(
        clientId: argResults?['client-id'] as String?,
        secret: argResults?['token'] as String?,
        env: argResults!['env'] as String,
      );
    } on ArgumentError {
      throw UsageException(
        'Supply --client-id and --token, or the CLI credential environment variables.',
        usage,
      );
    }
    stdout.writeln('DartStream CLI login validated and saved.');
  }
}

class _PublicCommand {
  const _PublicCommand(this.name, this.description);

  final String name;
  final String description;
}

const _publicCommands = [
  _PublicCommand('init', 'Initialize a new DartStream project.'),
  _PublicCommand('configure', 'Configure cloud, auth, database, and CI/CD.'),
  _PublicCommand(
    'setup',
    'Create local GitLab validation CI; middleware/tools coming soon.',
  ),
  _PublicCommand(
    'generate',
    'Generate local models, API routes or OpenAPI clients; other types coming soon.',
  ),
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

Future<void> _setExtensionEnabled(
  Directory workingDirectory,
  List<String>? args,
  bool enabled, {
  bool force = false,
}) async {
  if (args == null || args.isEmpty) {
    throw UsageException(
      'Missing extension name.',
      'dartstream ${enabled ? 'enable-extension' : 'disable-extension'} <name>',
    );
  }

  final name = args.first;
  if (args.length != 1 || name.trim().isEmpty) {
    throw UsageException(
      'Supply one nonempty extension name.',
      'dartstream enable-extension <name>',
    );
  }
  try {
    final registry = ExtensionRegistry(workingDirectory);
    final extensions = (registry.state['extensions'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    final existing = extensions.where((extension) => extension['name'] == name);
    if (!enabled &&
        !force &&
        existing.isNotEmpty &&
        existing.first['enabled'] == true) {
      final dependents = registry.enabledDependents(name);
      if (dependents.isNotEmpty) {
        throw FormatException(
          'Enabled extensions depend on $name: ${dependents.join(', ')}. '
          'Disable them first or explicitly use --force; no state changed.',
        );
      }
    }
    if (existing.isEmpty) {
      extensions.add({'name': name, 'enabled': enabled});
    } else {
      existing.first['enabled'] = enabled;
    }
    registry.save();
  } on FormatException catch (error) {
    throw UsageException(
      error.message,
      'dartstream ${enabled ? 'enable-extension' : 'disable-extension'} <name>',
    );
  } on FileSystemException catch (error) {
    throw UsageException(
      error.message,
      'dartstream ${enabled ? 'enable-extension' : 'disable-extension'} <name>',
    );
  }
  stdout.writeln('${enabled ? 'Enabled' : 'Disabled'} extension $name.');
}
