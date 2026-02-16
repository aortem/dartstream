import 'package:test/test.dart';
import 'package:ds_dartstream_standard_engine/core/ds_standard_core.dart';
import 'package:ds_lifecycle_base/ds_lifecycle_base.dart';

/// Test-only mock implementation
class MockLifecycleHook extends LifecycleHookAdapter {
  bool initialized = false;

  @override
  void onInitialize() {
    initialized = true;
  }
}

void main() {
  group('DSStandardCore', () {
    late DSStandardCore core;

    setUp(() {
      core = DSStandardCore(projectConfig: {'initial': 123});
    });

    test('initialization prints config', () async {
      await core.initialize();
      expect(core.getService('initial'), 123);
    });

    test('register and retrieve a service', () {
      core.registerService('service1', 'myService');
      expect(core.getService('service1'), 'myService');
    });

    test('register core extension with lifecycle hook', () {
      final mock = MockLifecycleHook();
      core.registerCoreExtension(
        extension: mock,
        baseFeature: 'featureA',
      );

      expect(mock.initialized, true);
      expect(core.getCoreExtension<MockLifecycleHook>('featureA'), mock);
    });

    test('register extended feature succeeds', () {
      final coreExt = MockLifecycleHook();
      core.registerCoreExtension(
        extension: coreExt,
        baseFeature: 'featureA',
      );

      final ext = MockLifecycleHook();
      final result = core.registerExtendedFeature(
        coreExtensionName: 'featureA',
        extension: ext,
        featureName: 'subFeature',
      );

      expect(result, true);
      expect(ext.initialized, true);
    });

    test('register extended feature fails if core extension missing', () {
      final ext = MockLifecycleHook();

      final result = core.registerExtendedFeature(
        coreExtensionName: 'nonExisting',
        extension: ext,
        featureName: 'subFeature',
      );

      expect(result, false);
    });
  });
}
