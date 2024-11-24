/// Abstract base class for feature flag providers in DartStream.
/// Ensures a consistent interface across all providers.
abstract class DSFeatureFlagProvider {
  /// Fetches the value of a feature flag as a boolean.
  /// Optionally accepts a context for evaluating the flag.
  Future<bool> getBooleanFlag(String flagKey,
      {bool defaultValue = false, Map<String, dynamic>? context});

  /// Fetches the value of a feature flag as a string.
  /// Optionally accepts a context for evaluating the flag.
  Future<String> getStringFlag(String flagKey,
      {String defaultValue = '', Map<String, dynamic>? context});

  /// Fetches the value of a feature flag as a number.
  /// Optionally accepts a context for evaluating the flag.
  Future<num> getNumberFlag(String flagKey,
      {num defaultValue = 0, Map<String, dynamic>? context});

  /// Fetches the value of a feature flag as JSON.
  /// Optionally accepts a context for evaluating the flag.
  Future<Map<String, dynamic>> getJsonFlag(String flagKey,
      {Map<String, dynamic> defaultValue = const {},
      Map<String, dynamic>? context});
}
