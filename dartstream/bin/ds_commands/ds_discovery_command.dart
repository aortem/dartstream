import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:args/command_runner.dart';
import '../../dartstream_backend/packages/standard/standard_extensions/platform_services/discovery/ds_discovery.dart';
import '../../dartstream_backend/packages/standard/standard_extensions/reactive_dataflow/lifecycle/base/ds_lifecycle_hooks.dart';

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
        print('- ${extension.name} (${extension.version})');
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
