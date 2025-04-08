import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:args/command_runner.dart';
import '../../dartstream_backend/packages/standard/standard_extensions/platform_services/discovery/ds_discovery.dart';

/// CLI Command for listing all registered extensions.
class DSListExtensionsCommand extends Command {
  @override
  final name = 'list-extensions';

  @override
  final description = 'Lists all discovered and registered extensions.';

  /// Constructor for initializing the list command.
  DSListExtensionsCommand() {
    argParser.addOption(
      'level',
      abbr: 'l',
      help: 'Filter by extension level',
      allowed: ['core', 'extended', 'third-party', 'all'],
      defaultsTo: 'all',
    );

    argParser.addFlag(
      'inactive',
      abbr: 'i',
      help: 'Include inactive extensions',
      negatable: false,
    );

    argParser.addFlag(
      'json',
      abbr: 'j',
      help: 'Output in JSON format',
      negatable: false,
    );
  }

  /// Executes the list extensions logic.
  @override
  Future<void> run() async {
    final args = argResults?.arguments ?? [];
    // Resolve extensions directory relative to this script
    final scriptDir = p.dirname(Platform.script.toFilePath());
    final extensionsDirectory =
        args.isNotEmpty
            ? args[0]
            : p.normalize(
              p.join(
                scriptDir,
                '../dartstream_backend/packages/standard/extensions',
              ),
            );
    final registryFile =
        args.length > 1
            ? args[1]
            : p.normalize(p.join(scriptDir, '../dartstream_registry.json'));

    final levelFilter = argResults?['level'] as String;
    final includeInactive = argResults?['inactive'] as bool;
    final jsonOutput = argResults?['json'] as bool;

    print('Listing extensions from the registry...');
    print('- Extensions directory: $extensionsDirectory');
    print('- Registry file: $registryFile');
    if (levelFilter != 'all') {
      print('- Filtering by level: $levelFilter');
    }
    if (includeInactive) {
      print('- Including inactive extensions');
    }

    try {
      final registry = ExtensionRegistry(
        extensionsDirectory: extensionsDirectory,
        registryFile: registryFile,
      );

      // Load and list extensions from the registry
      registry.discoverExtensions();

      if (registry.extensions.isEmpty) {
        print('No extensions discovered or registered.');
        return;
      }

      // Filter extensions by level if requested
      List<ExtensionManifest> filteredExtensions = [];
      switch (levelFilter) {
        case 'core':
          filteredExtensions = registry.coreExtensions;
          break;
        case 'extended':
          filteredExtensions = registry.extendedFeatures;
          break;
        case 'third-party':
          filteredExtensions = registry.thirdPartyEnhancements;
          break;
        default:
          filteredExtensions = registry.extensions;
      }

      if (jsonOutput) {
        _outputJson(
          filteredExtensions,
          registry.activeExtensions,
          includeInactive,
        );
      } else {
        _outputFormatted(
          filteredExtensions,
          registry.activeExtensions,
          includeInactive,
        );
      }
    } catch (e) {
      print('Error listing extensions: $e');
    }
  }

  void _outputFormatted(
    List<ExtensionManifest> extensions,
    List<String> activeExtensions,
    bool includeInactive,
  ) {
    // Group extensions by level
    final core = <ExtensionManifest>[];
    final extended = <ExtensionManifest>[];
    final thirdParty = <ExtensionManifest>[];

    for (final ext in extensions) {
      if (!includeInactive && !activeExtensions.contains(ext.name)) {
        continue;
      }

      switch (ext.level) {
        case ExtensionLevel.core:
          core.add(ext);
          break;
        case ExtensionLevel.extended:
          extended.add(ext);
          break;
        case ExtensionLevel.thirdParty:
          thirdParty.add(ext);
          break;
      }
    }

    print('\nRegistered Extensions:');

    if (core.isNotEmpty) {
      print('\n=== Core Extensions ===');
      for (final ext in core) {
        final active =
            activeExtensions.contains(ext.name) ? '(ACTIVE)' : '(INACTIVE)';
        print('- ${ext.name} ${ext.version} $active');
        print('  Description: ${ext.description}');
      }
    }

    if (extended.isNotEmpty) {
      print('\n=== Extended Features ===');
      for (final ext in extended) {
        final active =
            activeExtensions.contains(ext.name) ? '(ACTIVE)' : '(INACTIVE)';
        final core =
            ext.coreExtension != null ? 'for ${ext.coreExtension}' : '';
        print('- ${ext.name} ${ext.version} $active $core');
        print('  Description: ${ext.description}');
      }
    }

    if (thirdParty.isNotEmpty) {
      print('\n=== Third-Party Enhancements ===');
      for (final ext in thirdParty) {
        final active =
            activeExtensions.contains(ext.name) ? '(ACTIVE)' : '(INACTIVE)';
        print('- ${ext.name} ${ext.version} $active');
        print('  Description: ${ext.description}');
      }
    }

    print('\nTotal: ${extensions.length} extensions');
  }

  void _outputJson(
    List<ExtensionManifest> extensions,
    List<String> activeExtensions,
    bool includeInactive,
  ) {
    final result = {
      'extensions':
          extensions
              .where(
                (ext) => includeInactive || activeExtensions.contains(ext.name),
              )
              .map(
                (ext) => {
                  ...ext.toJson(),
                  'active': activeExtensions.contains(ext.name),
                },
              )
              .toList(),
      'totalCount': extensions.length,
      'activeCount':
          extensions.where((ext) => activeExtensions.contains(ext.name)).length,
    };

    print(result);
  }
}
