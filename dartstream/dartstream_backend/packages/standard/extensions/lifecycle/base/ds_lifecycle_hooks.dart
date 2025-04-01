/// Interface for defining lifecycle hooks in Dartstream extensions.
/// Allows extensions to execute code at specific points in their lifecycle.
mixin LifecycleHook {
  /// Called when the extension is initialized.
  void onInitialize() {
    print('Default onInitialize executed in mixin.');
  }

  /// Called when the extension is disposed.
  void onDispose() {
    print('Default onDispose executed in mixin.');
  }
}

/// Example of a default implementation that uses the LifecycleHook mixin.
/// This class can be extended or used as is by extensions to inherit default behavior.
class DefaultLifecycleHook with LifecycleHook {
  @override
  void onInitialize() {
    super.onInitialize();
    print('Custom onInitialize logic for DefaultLifecycleHook.');
  }

  @override
  void onDispose() {
    super.onDispose();
    print('Custom onDispose logic for DefaultLifecycleHook.');
  }
}
