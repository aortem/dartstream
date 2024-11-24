import 'package:args/command_runner.dart';
import '../../dartstream_backend/packages/standard/extensions/discovery/ds_discovery.dart';
import '../../dartstream_backend/packages/standard/extensions/lifecycle/base/ds_lifecycle_hooks.dart';

/// CLI Command for Dartstream to discover and manage extensions dynamically.
/// Provides options for discovering extensions and invoking lifecycle hooks.
class DSDiscoveryCommand extends Command {
  @override
  final name = 'discover';

  @override
  final description =
      'Discovers, validates, and dynamically registers extensions.';

  /// Constructor to initialize the discovery command.
  DSDiscoveryCommand();

  /// Executes the discovery logic.
  /// This includes scanning the extensions directory, validating dependencies, and managing lifecycle hooks.
  @override
  Future<void> run() async {
    // Retrieve CLI arguments or use defaults for discovery.
    final args = argResults?.arguments ?? [];
    final extensionsDirectory = args.isNotEmpty ? args[0] : 'extensions';
    final registryFile = args.length > 1 ? args[1] : 'dartstream_registry.json';

    print('Starting extension discovery...');
    print('- Extensions directory: $extensionsDirectory');
    print('- Registry file: $registryFile');

    try {
      // Initialize the registry for discovery.
      final registry = ExtensionRegistry(
        extensionsDirectory: extensionsDirectory,
        registryFile: registryFile,
      );

      // Discover and dynamically register extensions.
      registry.discoverExtensions();

      print('\nDiscovery complete. Registered extensions:');
      for (final extension in registry.extensions) {
        print('- ${extension.name} (${extension.version})');

        // Trigger lifecycle hooks if applicable.
        if (extension is LifecycleHook) {
          print('> Initializing ${extension.name}...');
          extension.onInitialize();
        }
      }

      print('\nLifecycle hooks executed successfully.');
    } catch (e) {
      // Handle errors gracefully during the discovery process.
      print('Error during discovery: $e');
    }
  }
}
