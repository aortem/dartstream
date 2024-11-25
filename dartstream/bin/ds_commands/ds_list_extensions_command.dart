import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:args/command_runner.dart';
import '../../dartstream_backend/packages/standard/extensions/discovery/ds_discovery.dart';

/// CLI Command for listing all registered extensions.
class DSListExtensionsCommand extends Command {
  @override
  final name = 'list-extensions';

  @override
  final description = 'Lists all discovered and registered extensions.';

  /// Constructor for initializing the list command.
  DSListExtensionsCommand();

  /// Executes the list extensions logic.
  @override
  Future<void> run() async {
    final args = argResults?.arguments ?? [];
    // Resolve extensions directory relative to this script
    final scriptDir = p.dirname(Platform.script.toFilePath());
    final extensionsDirectory = args.isNotEmpty
        ? args[0]
        : p.normalize(p.join(
            scriptDir, '../dartstream_backend/packages/standard/extensions'));
    final registryFile = args.length > 1
        ? args[1]
        : p.normalize(p.join(scriptDir, '../dartstream_registry.json'));

    print('Listing extensions from the registry...');
    print('- Extensions directory: $extensionsDirectory');
    print('- Registry file: $registryFile\n');

    try {
      final registry = ExtensionRegistry(
        extensionsDirectory: extensionsDirectory,
        registryFile: registryFile,
      );

      // Load and list extensions from the registry
      registry.discoverExtensions();

      if (registry.extensions.isEmpty) {
        print('No extensions discovered or registered.');
      } else {
        print('Discovered extensions:');
        for (final extension in registry.extensions) {
          print('- ${extension.name} (${extension.version})');
        }
      }
    } catch (e) {
      print('Error listing extensions: $e');
    }
  }
}
