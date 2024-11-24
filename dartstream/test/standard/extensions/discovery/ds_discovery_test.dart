import 'dart:io';
import 'package:test/test.dart';
import '../../../../dartstream_backend/packages/standard/extensions/discovery/ds_discovery.dart';
import '../../../../dartstream_backend/packages/standard/extensions/lifecycle/base/ds_lifecycle_hooks.dart';

class MockExtension extends ExtensionManifest with LifecycleHook {
  MockExtension()
      : super(
          'MockExtension',
          '1.0.0',
          'A mock extension for testing.',
          [],
          'mock_entry_point',
        );

  @override
  void onInitialize() {
    print('MockExtension initialized.');
  }

  @override
  void onDispose() {
    print('MockExtension disposed.');
  }
}

void main() {
  group('ExtensionRegistry Tests', () {
    late ExtensionRegistry registry;

    setUp(() {
      registry = ExtensionRegistry(extensionsDirectory: 'test_extensions');
    });

    test('Discover extensions with valid lifecycle hooks', () {
      // Create a mock extensions directory and manifest.yaml
      final mockDir = Directory('test_extensions/MockExtension')
        ..createSync(recursive: true);
      File('${mockDir.path}/manifest.yaml')
        ..createSync()
        ..writeAsStringSync('''
          name: MockExtension
          version: 1.0.0
          description: A mock extension for testing.
          entry_point: mock_entry_point
          dependencies: []
        ''');

      registry.discoverExtensions();
      expect(registry.extensions.length, equals(1));

      // Check if lifecycle hooks are triggered
      final extension = registry.extensions.first;
      expect(extension.name, equals('MockExtension'));
    });

    test('Lifecycle hooks: onInitialize and onDispose', () {
      final mockExtension = MockExtension();
      registry.registerExtension(mockExtension);

      // Ensure onInitialize is called
      expect(() => mockExtension.onInitialize(),
          prints('MockExtension initialized.\n'));

      // Ensure onDispose is called
      registry.unregisterExtension(mockExtension);
      expect(
          () => mockExtension.onDispose(), prints('MockExtension disposed.\n'));
    });
  });
}
