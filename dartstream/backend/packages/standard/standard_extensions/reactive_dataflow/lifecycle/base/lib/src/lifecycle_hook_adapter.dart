import 'ds_lifecycle_hooks.dart';

/// Convenience base class for lifecycle-aware extensions
abstract class LifecycleHookAdapter with LifecycleHook {
  @override
  void onInitialize() {}

  @override
  void onRegister() {}

  @override
  void onConfigUpdate(Map<String, dynamic> config) {}

  @override
  void onDispose() {}
}
