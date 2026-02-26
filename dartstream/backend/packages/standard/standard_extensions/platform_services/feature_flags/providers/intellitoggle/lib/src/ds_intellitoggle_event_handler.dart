import 'package:openfeature_provider_intellitoggle/openfeature_provider_intellitoggle.dart';

/// Handles lifecycle events emitted by the IntelliToggle provider.
///
/// Listens to provider events such as readiness, configuration changes,
/// and errors, and maps them to DartStream-compatible callbacks.
///
/// Example usage:
/// ```dart
/// final eventHandler = DSIntelliToggleEventHandler(provider: provider);
/// eventHandler.initialize();
/// ```
class DSIntelliToggleEventHandler {
  final IntelliToggleProvider provider;

  /// Callback triggered when the provider is ready.
  void Function()? onReady;

  /// Callback triggered when flags are updated.
  void Function(List<String> flagsChanged)? onConfigurationChanged;

  /// Callback triggered when an error occurs.
  void Function(String message)? onError;

  /// Creates a DSIntelliToggleEventHandler.
  DSIntelliToggleEventHandler({
    required this.provider,
    this.onReady,
    this.onConfigurationChanged,
    this.onError,
  });

  /// Initializes event listeners for the IntelliToggle provider.
  /// Initializes event listeners for the IntelliToggle provider.
  /// Initializes event listeners for the IntelliToggle provider.
  void initialize() {
    provider.events.listen((event) {
      switch (event.type) {
        case IntelliToggleEventType.ready:
          _handleReady();
          break;
        case IntelliToggleEventType.configurationChanged:
          _handleConfigurationChanged(event);
          break;
        case IntelliToggleEventType.error:
          _handleError(event);
          break;
        default:
          // Handle other event types (initializing, shutdown, flagEvaluated, etc.)
          break;
      }
    });
  }

  void _handleReady() {
    print('✓ DSIntelliToggleProvider is ready.');
    onReady?.call();
  }

  void _handleConfigurationChanged(dynamic event) {
    final flagsChanged = (event.data?['flagsChanged'] as List?)
            ?.cast<String>() ??
        [];
    print('⚡ IntelliToggle flags updated: $flagsChanged');
    onConfigurationChanged?.call(flagsChanged);
  }

  void _handleError(dynamic event) {
    final message = event.message ?? 'Unknown error';
    print('✗ DSIntelliToggleProvider error: $message');
    onError?.call(message);
  }
}