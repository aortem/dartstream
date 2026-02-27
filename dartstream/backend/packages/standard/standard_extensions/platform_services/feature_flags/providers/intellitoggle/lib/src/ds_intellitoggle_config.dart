import 'package:openfeature_provider_intellitoggle/openfeature_provider_intellitoggle.dart';

/// Configuration options for the DSIntelliToggleProvider.
///
/// Provides sensible defaults and supports both production
/// and development environment presets.
///
/// Example usage:
/// ```dart
/// // Production config
/// final config = DSIntelliToggleConfig.production();
///
/// // Development config
/// final config = DSIntelliToggleConfig.development();
///
/// // Custom config
/// final config = DSIntelliToggleConfig(
///   enableLogging: true,
///   pollingInterval: Duration(minutes: 2),
/// );
/// ```
class DSIntelliToggleConfig {
  /// API base URL for IntelliToggle service.
  final Uri baseUri;

  /// Maximum request duration before failing.
  final Duration timeout;

  /// Whether to poll periodically for configuration changes.
  final bool enablePolling;

  /// How often to poll for updates when polling is enabled.
  final Duration pollingInterval;

  /// Enables real-time updates from the service if supported.
  final bool enableStreaming;

  /// Number of retry attempts for failed requests.
  final int maxRetries;

  /// Enables verbose debug logging for troubleshooting.
  final bool enableLogging;

  /// Creates a custom DSIntelliToggleConfig.
  DSIntelliToggleConfig({
    Uri? baseUri,
    Duration? timeout,
    bool? enablePolling,
    Duration? pollingInterval,
    bool? enableStreaming,
    int? maxRetries,
    bool? enableLogging,
  })  : baseUri = baseUri ?? Uri.parse('https://api.intellitoggle.com'),
        timeout = timeout ?? const Duration(seconds: 10),
        enablePolling = enablePolling ?? true,
        pollingInterval = pollingInterval ?? const Duration(minutes: 5),
        enableStreaming = enableStreaming ?? false,
        maxRetries = maxRetries ?? 3,
        enableLogging = enableLogging ?? false;

  /// Production preset configuration.
  factory DSIntelliToggleConfig.production({
    Duration? timeout,
    Duration? pollingInterval,
  }) {
    return DSIntelliToggleConfig(
      baseUri: Uri.parse('https://api.intellitoggle.com'),
      timeout: timeout ?? const Duration(seconds: 10),
      enablePolling: true,
      pollingInterval: pollingInterval ?? const Duration(minutes: 5),
      enableStreaming: false,
      maxRetries: 3,
      enableLogging: false,
    );
  }

  /// Development preset configuration.
  factory DSIntelliToggleConfig.development({
    Uri? baseUri,
    Duration? timeout,
  }) {
    return DSIntelliToggleConfig(
      baseUri: baseUri ?? Uri.parse('http://localhost:8080'),
      timeout: timeout ?? const Duration(seconds: 5),
      enablePolling: true,
      pollingInterval: const Duration(minutes: 1),
      enableStreaming: false,
      maxRetries: 1,
      enableLogging: true,
    );
  }

  /// Converts to IntelliToggleOptions for the official SDK.
  IntelliToggleOptions toIntelliToggleOptions() {
    return IntelliToggleOptions(
      timeout: timeout,
      enablePolling: enablePolling,
      pollingInterval: pollingInterval,
      enableStreaming: enableStreaming,
      maxRetries: maxRetries,
      enableLogging: enableLogging,
    );
  }
}