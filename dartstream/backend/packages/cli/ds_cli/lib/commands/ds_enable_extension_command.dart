import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:args/command_runner.dart';
import 'package:ds_discovery_provider/main.dart';

class DSEnableExtensionCommand extends Command {
  @override
  final name = 'enable-extension';

  @override
  final description = 'Enables a specified extension.';

  DSEnableExtensionCommand() {
    argParser.addOption(
      'level',
      abbr: 'l',
      help: 'Extension level (core, extended, third-party)',
      allowed: ['core', 'extended', 'third-party'],
      defaultsTo: 'third-party',
    );
  }

  @override
  Future<void> run() async {
    final args = argResults?.arguments ?? [];
    if (args.isEmpty) {
      print('Error: Please specify the name of the extension to enable.');
      return;
    }

    final extensionName = args[0];
    final extensionLevel = argResults?['level'];

    // Resolve extensions directory relative to this script
    final scriptDir = p.dirname(Platform.script.toFilePath());
    final extensionsDirectory = p.normalize(
      p.join(scriptDir, '../dartstream_backend/packages/standard/extensions'),
    );
    final registryFile = p.normalize(
      p.join(scriptDir, '../dartstream_registry.yaml'),
    );

    print('Enabling extension: $extensionName');
    print('- Extensions directory: $extensionsDirectory');
    print('- Registry file: $registryFile');
    print('- Extension level: $extensionLevel');

    try {
      final registry = ExtensionRegistry(
        extensionsDirectory: extensionsDirectory,
        registryFile: registryFile,
      );

      // Load extensions
      registry.discoverExtensions();

      // Check if the extension exists
      final extension = registry.extensions
          .where((ext) => ext.name == extensionName)
          .firstOrNull;

      if (extension == null) {
        print('Error: Extension "$extensionName" not found.');

        // Suggest similar extensions
        final similarExtensions = registry.extensions
            .where(
              (ext) =>
                  ext.name.toLowerCase().contains(extensionName.toLowerCase()),
            )
            .map((ext) => ext.name)
            .toList();

        if (similarExtensions.isNotEmpty) {
          print('\nDid you mean one of these?');
          for (final name in similarExtensions) {
            print('- $name');
          }
        }
        return;
      }

      // Enable the extension
      registry.enableExtension(extensionName);
      registry.saveActiveExtensions();

      print('Extension "$extensionName" has been enabled successfully.');
    } catch (e) {
      print('Error enabling extension: $e');
    }
  }
}

extension FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
