// ds_lifecycle_hooks.dart

/// Interface for defining lifecycle hooks in Dartstream extensions.
/// Allows extensions to execute code at specific points in their lifecycle.
abstract class LifecycleHook {
  /// Called when the extension is initialized.
  void onInitialize();

  /// Called when the extension is disposed.
  void onDispose();
}
