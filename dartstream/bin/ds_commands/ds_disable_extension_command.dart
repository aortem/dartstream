import 'package:args/command_runner.dart';
import '../../dartstream_backend/packages/standard/standard_extensions/platform_services/discovery/ds_discovery.dart';

class DSDisableExtensionCommand extends Command {
  @override
  final name = 'disable-extension';
  @override
  final description = 'Disables a specified extension.';

  @override
  Future<void> run() async {
    final args = argResults?.arguments ?? [];
    if (args.isEmpty) {
      print('Error: Please specify the name of the extension to disable.');
      return;
    }
    final extensionName = args[0];
    final registry = ExtensionRegistry(
      extensionsDirectory: 'path/to/extensions',
      registryFile: 'path/to/registry.json',
    );
    registry.discoverExtensions(); // Ensure registry is populated
    registry.disableExtension(extensionName);
    registry.saveActiveExtensions();
  }
}
