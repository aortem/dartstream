import 'ds_notification_provider.dart';

/// Metadata for registered notification providers.
class DSNotificationProviderMetadata {
  /// Provider type (e.g., fcm).
  final String type;

  /// Optional vendor name.
  final String? vendor;

  /// Optional region information.
  final String? region;

  /// Additional provider-specific metadata.
  final Map<String, dynamic>? additionalMetadata;

  /// Constructor.
  DSNotificationProviderMetadata({
    required this.type,
    this.vendor,
    this.region,
    this.additionalMetadata,
  });
}

/// Central manager for notification providers in DartStream.
class DSNotificationManager {
  /// Registry of notification providers.
  static final Map<String, DSNotificationProvider> _registeredProviders = {};

  /// Metadata for registered providers.
  static final Map<String, DSNotificationProviderMetadata> _providerMetadata = {};

  /// Enable debug logging.
  static bool enableDebugging = false;

  /// Log messages when debugging is enabled.
  static void log(String message) {
    if (enableDebugging) {
      print('DSNotificationManager: $message');
    }
  }

  /// Register a new notification provider.
  static void registerProvider(
    String name,
    DSNotificationProvider provider,
    DSNotificationProviderMetadata metadata,
  ) {
    _registeredProviders[name] = provider;
    _providerMetadata[name] = metadata;
    log('Registered notification provider: $name (${metadata.type})');
  }

  /// Get metadata for a provider.
  static DSNotificationProviderMetadata? getProviderMetadata(
    String providerName,
  ) {
    return _providerMetadata[providerName];
  }

  /// Get all registered provider names.
  static List<String> getRegisteredProviderNames() {
    return _registeredProviders.keys.toList();
  }

  /// Get providers by type.
  static List<String> getProvidersByType(String type) {
    return _providerMetadata.entries
        .where((entry) => entry.value.type == type)
        .map((entry) => entry.key)
        .toList();
  }

  /// Active notification provider.
  late DSNotificationProvider _provider;

  /// Initialize the manager with a specific provider.
  DSNotificationManager(String providerName) {
    if (!_registeredProviders.containsKey(providerName)) {
      throw DSNotificationError('Provider not registered: $providerName');
    }
    _provider = _registeredProviders[providerName]!;
    log('Initialized manager with provider: $providerName');
  }

  /// Initialize the provider with configuration.
  Future<void> initialize(Map<String, dynamic> config) async {
    log('Initializing provider with config...');
    await _provider.initialize(config);
  }

  /// Send a notification.
  Future<void> send(DSNotificationRequest request) {
    log('Sending notification to: ${request.target}');
    return _provider.send(request);
  }

  /// Dispose of the provider.
  Future<void> dispose() {
    log('Disposing notification provider...');
    return _provider.dispose();
  }
}
