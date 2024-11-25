import 'package:args/command_runner.dart';
import '../../dartstream_backend/packages/standard/extensions/discovery/ds_discovery.dart';

class DSEnableExtensionCommand extends Command {
  @override
  final name = 'enable-extension';
  @override
  final description = 'Enables a specified extension.';

  @override
  Future<void> run() async {
    final args = argResults?.arguments ?? [];
    if (args.isEmpty) {
      print('Error: Please specify the name of the extension to enable.');
      return;
    }
    final extensionName = args[0];
    final registry = ExtensionRegistry(
      extensionsDirectory: 'path/to/extensions',
      registryFile: 'path/to/registry.json',
    );
    registry.discoverExtensions(); // Ensure registry is populated
    registry.enableExtension(extensionName);
    registry.saveActiveExtensions();
  }
}
