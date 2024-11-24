import 'ds_feature_flag_provider.dart';

/// Manages feature flag providers and allows centralized flag querying.
class DSFeatureFlagManager {
  static final Map<String, DSFeatureFlagProvider> _registeredProviders = {};

  /// Registers a feature flag provider.
  static void registerProvider(String name, DSFeatureFlagProvider provider) {
    if (_registeredProviders.containsKey(name)) {
      throw ArgumentError('Provider already registered: $name');
    }
    _registeredProviders[name] = provider;
  }

  /// Fetches a feature flag as a boolean from the specified provider.
  static Future<bool> getBooleanFlag(
    String providerName,
    String flagKey, {
    bool defaultValue = false,
    Map<String, dynamic>? context,
  }) async {
    final provider = _getProvider(providerName);
    return provider.getBooleanFlag(
      flagKey,
      defaultValue: defaultValue,
      context: context,
    );
  }

  /// Fetches a feature flag as a string from the specified provider.
  static Future<String> getStringFlag(
    String providerName,
    String flagKey, {
    String defaultValue = '',
    Map<String, dynamic>? context,
  }) async {
    final provider = _getProvider(providerName);
    return provider.getStringFlag(
      flagKey,
      defaultValue: defaultValue,
      context: context,
    );
  }

  /// Fetches a feature flag as a number from the specified provider.
  static Future<num> getNumberFlag(
    String providerName,
    String flagKey, {
    num defaultValue = 0,
    Map<String, dynamic>? context,
  }) async {
    final provider = _getProvider(providerName);
    return provider.getNumberFlag(
      flagKey,
      defaultValue: defaultValue,
      context: context,
    );
  }

  /// Fetches a feature flag as JSON from the specified provider.
  static Future<Map<String, dynamic>> getJsonFlag(
    String providerName,
    String flagKey, {
    Map<String, dynamic> defaultValue = const {},
    Map<String, dynamic>? context,
  }) async {
    final provider = _getProvider(providerName);
    return provider.getJsonFlag(
      flagKey,
      defaultValue: defaultValue,
      context: context,
    );
  }

  /// Returns a registered provider by name.
  static DSFeatureFlagProvider _getProvider(String providerName) {
    if (!_registeredProviders.containsKey(providerName)) {
      throw ArgumentError('Provider not registered: $providerName');
    }
    return _registeredProviders[providerName]!;
  }
}
