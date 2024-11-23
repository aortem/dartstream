import 'package:args/command_runner.dart';
import 'dart:io';
import '../../dartstream_backend/packages/standard/extensions/discovery/ds_discovery.dart';

class DSDiscoverCommand extends Command {
  @override
  final name = 'discover';
  @override
  final description = 'Discover and register DartStream extensions.';

  DSDiscoverCommand();

  @override
  void run() {
    final registry = ExtensionRegistry(
      extensionsDirectory: 'dartstream_backend/packages/standard/extensions',
      registryFile:
          'dartstream_backend/packages/config/registered_extensions.json',
    );

    print('Discovering extensions...');
    registry.discoverExtensions();

    print('\nDiscovered Extensions:');
    for (var ext in registry.extensions) {
      print(' - ${ext.name} (${ext.version})');
    }
  }
}
