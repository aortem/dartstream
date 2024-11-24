/// Interface for defining lifecycle hooks in Dartstream extensions.
/// Allows extensions to execute code at specific points in their lifecycle.
abstract class LifecycleHook {
  /// Called when the extension is initialized.
  void onInitialize();

  /// Called when the extension is disposed.
  void onDispose();
}

/// Default implementation of LifecycleHook for optional override by extensions.
class DefaultLifecycleHook implements LifecycleHook {
  @override
  void onInitialize() {
    print('Default onInitialize executed.');
  }

  @override
  void onDispose() {
    print('Default onDispose executed.');
  }
}
