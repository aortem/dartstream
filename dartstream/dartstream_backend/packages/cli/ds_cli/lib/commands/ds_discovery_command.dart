import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:args/command_runner.dart';
import 'package:ds_discovery_provider/main.dart';
import 'package:ds_lifecycle_base/main.dart';

/// CLI Command for Dartstream to discover and manage extensions dynamically.
class DSDiscoveryCommand extends Command {
  @override
  final name = 'discover';

  @override
  final description =
      'Discovers, validates, and dynamically registers extensions.';

  /// Constructor to initialize the discovery command.
  DSDiscoveryCommand();

  /// Executes the discovery logic.
  @override
  Future<void> run() async {
    final args = argResults?.arguments ?? [];

    // Try different directory paths to find the correct one
    final List<String> possiblePaths = [
      // Path from original code
      p.join('..', 'dartstream_backend', 'packages', 'standard', 'extensions'),

      // Path from log output showing success
      p.join(
        '..',
        'dartstream_backend',
        'packages',
        'standard',
        'standard_extensions',
      ),

      // Additional possible paths
      p.join('dartstream_backend', 'packages', 'standard', 'extensions'),
      p.join(
        'dartstream_backend',
        'packages',
        'standard',
        'standard_extensions',
      ),

      // Direct paths
      'packages/standard/extensions',
      'packages/standard/standard_extensions',

      // Use argument if provided
      if (args.isNotEmpty) args[0],
    ];

    // Resolve script directory
    final scriptDir = p.dirname(Platform.script.toFilePath());

    // Try each path until we find one that exists
    String? extensionsDirectory;
    for (final pathCandidate in possiblePaths) {
      final fullPath = p.normalize(p.join(scriptDir, pathCandidate));
      if (Directory(fullPath).existsSync()) {
        extensionsDirectory = fullPath;
        break;
      }
    }

    // Fall back to argument 0 if provided, even if it doesn't exist
    extensionsDirectory ??= args.isNotEmpty
        ? args[0]
        : p.normalize(
            p.join(
              scriptDir,
              '..',
              'dartstream_backend',
              'packages',
              'standard',
              'standard_extensions',
            ),
          );

    final registryFile = args.length > 1
        ? args[1]
        : p.normalize(p.join(scriptDir, '..', 'dartstream_registry.yaml'));

    print('Starting extension discovery...');
    print('- Extensions directory: $extensionsDirectory');
    print('- Registry file: $registryFile');

    try {
      final registry = ExtensionRegistry(
        extensionsDirectory: extensionsDirectory,
        registryFile: registryFile,
      );

      registry.discoverExtensions();

      print('\nDiscovery complete. Registered extensions:');
      for (final extension in registry.extensions) {
        print(
          '- ${extension.name} (${extension.version}) - Level: ${extension.level}',
        );
        if (extension is LifecycleHook) {
          extension.onInitialize();
        }
      }

      print('\nLifecycle hooks executed successfully.');
    } catch (e) {
      print('Error during discovery: $e');
    }
  }
}
