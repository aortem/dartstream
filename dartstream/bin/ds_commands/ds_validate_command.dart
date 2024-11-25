import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:args/command_runner.dart';
import '../../dartstream_backend/packages/standard/extensions/discovery/ds_discovery.dart';

/// CLI Command for validating extensions.
class DSValidateCommand extends Command {
  @override
  final name = 'validate';

  @override
  final description =
      'Validates all discovered extensions for manifest correctness and dependency compatibility.';

  /// Constructor to initialize the validate command.
  DSValidateCommand();

  /// Executes the validation logic.
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

    print('Validating extensions...');
    print('- Extensions directory: $extensionsDirectory');
    print('- Registry file: $registryFile\n');

    try {
      final registry = ExtensionRegistry(
        extensionsDirectory: extensionsDirectory,
        registryFile: registryFile,
      );

      registry.discoverExtensions();

      if (registry.extensions.isEmpty) {
        print('No extensions discovered for validation.');
        return;
      }

      bool allValid = true;

      for (final extension in registry.extensions) {
        print('Validating extension: ${extension.name} (${extension.version})');

        // Validate manifest fields
        if (!_validateManifestFields(extension)) {
          allValid = false;
          print(
              'Error: Missing required fields in the manifest of ${extension.name}.');
          continue;
        }

        // Validate dependencies
        if (!registry.validateDependencies(extension)) {
          allValid = false;
          print('Error: Dependency issues detected for ${extension.name}.');
          continue;
        }

        print('Validation successful for ${extension.name}.\n');
      }

      if (allValid) {
        print('All extensions validated successfully.');
      } else {
        print('Some extensions failed validation. Check the errors above.');
      }
    } catch (e) {
      print('Error during validation: $e');
    }
  }

  /// Validates required fields in the manifest.
  bool _validateManifestFields(ExtensionManifest extension) {
    return extension.name.isNotEmpty &&
        extension.version.isNotEmpty &&
        extension.entryPoint.isNotEmpty;
  }
}
