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

  /// Called when the extension is being registered
  void onRegister() {
    print('Default onRegister executed in mixin.');
  }

  /// Called when the extension configuration is updated
  void onConfigUpdate(Map<String, dynamic> config) {
    print('Default onConfigUpdate executed in mixin.');
  }
}

/// Core extension lifecycle interface for core extensions
mixin CoreExtensionLifecycle implements LifecycleHook {
  /// Called when the framework is starting
  void onFrameworkStart() {
    print('Default onFrameworkStart executed in CoreExtensionLifecycle.');
  }

  /// Called when the framework is stopping
  void onFrameworkStop() {
    print('Default onFrameworkStop executed in CoreExtensionLifecycle.');
  }

  /// Called when a dependent extended feature is registered
  void onExtendedFeatureAdded(String featureName) {
    print('Extended feature $featureName added to core extension.');
  }

  /// Called when a dependent extended feature is removed
  void onExtendedFeatureRemoved(String featureName) {
    print('Extended feature $featureName removed from core extension.');
  }
}

/// Extended feature lifecycle interface for features that extend core functionality
mixin ExtendedFeatureLifecycle implements LifecycleHook {
  /// Called when the parent core extension is initialized
  void onCoreInitialized() {
    print('Default onCoreInitialized executed in ExtendedFeatureLifecycle.');
  }

  /// Called to enhance the core functionality
  void enhance() {
    print('Default enhance executed in ExtendedFeatureLifecycle.');
  }

  /// Called when the parent core extension is being disposed
  void onCoreDisposing() {
    print('Default onCoreDisposing executed in ExtendedFeatureLifecycle.');
  }
}

/// Third-party enhancement lifecycle interface for external enhancements
mixin ThirdPartyLifecycle implements LifecycleHook {
  /// Called to integrate with the framework
  void integrate() {
    print('Default integrate executed in ThirdPartyLifecycle.');
  }

  /// Called when compatibility should be checked
  bool checkCompatibility() {
    print('Default checkCompatibility executed in ThirdPartyLifecycle.');
    return true;
  }

  /// Called when version is updated
  void onVersionUpdate(String oldVersion, String newVersion) {
    print('Version updated from $oldVersion to $newVersion.');
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

  @override
  void onRegister() {
    super.onRegister();
    print('Custom onRegister logic for DefaultLifecycleHook.');
  }

  @override
  void onConfigUpdate(Map<String, dynamic> config) {
    super.onConfigUpdate(config);
    print('Custom onConfigUpdate logic for DefaultLifecycleHook.');
  }
}

/// Default implementation for core extensions
class DefaultCoreExtensionHook with LifecycleHook, CoreExtensionLifecycle {
  @override
  void onFrameworkStart() {
    super.onFrameworkStart();
    print('Custom onFrameworkStart logic for DefaultCoreExtensionHook.');
  }

  @override
  void onFrameworkStop() {
    super.onFrameworkStop();
    print('Custom onFrameworkStop logic for DefaultCoreExtensionHook.');
  }
}

/// Default implementation for extended features
class DefaultExtendedFeatureHook with LifecycleHook, ExtendedFeatureLifecycle {
  @override
  void onCoreInitialized() {
    super.onCoreInitialized();
    print('Custom onCoreInitialized logic for DefaultExtendedFeatureHook.');
  }

  @override
  void enhance() {
    super.enhance();
    print('Custom enhance logic for DefaultExtendedFeatureHook.');
  }
}

/// Default implementation for third-party enhancements
class DefaultThirdPartyHook with LifecycleHook, ThirdPartyLifecycle {
  @override
  void integrate() {
    super.integrate();
    print('Custom integrate logic for DefaultThirdPartyHook.');
  }

  @override
  bool checkCompatibility() {
    print('Custom checkCompatibility logic for DefaultThirdPartyHook.');
    return true;
  }
}
