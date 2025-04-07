import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:args/command_runner.dart';
import '../../dartstream_backend/packages/standard/standard_extensions/platform_services/discovery/ds_discovery.dart';

class DSDisableExtensionCommand extends Command {
  @override
  final name = 'disable-extension';

  @override
  final description = 'Disables a specified extension.';

  DSDisableExtensionCommand() {
    argParser.addFlag(
      'force',
      abbr: 'f',
      help: 'Force disable even if dependencies exist',
      negatable: false,
    );
  }

  @override
  Future<void> run() async {
    final args = argResults?.arguments ?? [];
    if (args.isEmpty) {
      print('Error: Please specify the name of the extension to disable.');
      return;
    }

    final extensionName = args[0];
    final forceDisable = argResults?['force'] ?? false;

    // Resolve extensions directory relative to this script
    final scriptDir = p.dirname(Platform.script.toFilePath());
    final extensionsDirectory = p.normalize(
      p.join(scriptDir, '../dartstream_backend/packages/standard/extensions'),
    );
    final registryFile = p.normalize(
      p.join(scriptDir, '../dartstream_registry.json'),
    );

    print('Disabling extension: $extensionName');
    print('- Extensions directory: $extensionsDirectory');
    print('- Registry file: $registryFile');
    print('- Force disable: $forceDisable');

    try {
      final registry = ExtensionRegistry(
        extensionsDirectory: extensionsDirectory,
        registryFile: registryFile,
      );

      // Load extensions
      registry.discoverExtensions();

      // Check if the extension exists and is active
      final extension =
          registry.extensions
              .where((ext) => ext.name == extensionName)
              .firstOrNull;

      if (extension == null) {
        print('Error: Extension "$extensionName" not found.');
        return;
      }

      if (!registry.activeExtensions.contains(extensionName)) {
        print('Extension "$extensionName" is already disabled.');
        return;
      }

      // Check for dependent extensions if not forcing
      if (!forceDisable && extension.level == ExtensionLevel.core) {
        final dependentExtensions =
            registry.extendedFeatures
                .where((ext) => ext.coreExtension == extensionName)
                .toList();

        if (dependentExtensions.isNotEmpty) {
          print(
            'Error: Cannot disable core extension "$extensionName" because it has dependent extended features:',
          );
          for (final dep in dependentExtensions) {
            print('- ${dep.name}');
          }
          print('Use --force to disable anyway (may cause issues).');
          return;
        }
      }

      // Disable the extension
      registry.disableExtension(extensionName);
      registry.saveActiveExtensions();

      print('Extension "$extensionName" has been disabled successfully.');
    } catch (e) {
      print('Error disabling extension: $e');
    }
  }
}

extension FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
