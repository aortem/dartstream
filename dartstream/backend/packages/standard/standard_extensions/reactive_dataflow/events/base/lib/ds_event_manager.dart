import 'ds_event_provider.dart';

/// Metadata for registered event providers.
class DSEventProviderMetadata {
  /// Provider type (e.g., eventarc).
  final String type;

  /// Optional vendor name (e.g., gcp).
  final String? vendor;

  /// Optional region information.
  final String? region;

  /// Additional provider-specific metadata.
  final Map<String, dynamic>? additionalMetadata;

  /// Constructor.
  DSEventProviderMetadata({
    required this.type,
    this.vendor,
    this.region,
    this.additionalMetadata,
  });
}

/// Central manager for event providers in DartStream.
class DSEventManager {
  /// Registry of event providers.
  static final Map<String, DSEventProvider> _registeredProviders = {};

  /// Metadata for registered providers.
  static final Map<String, DSEventProviderMetadata> _providerMetadata = {};

  /// Enable debug logging.
  static bool enableDebugging = false;

  /// Log messages when debugging is enabled.
  static void log(String message) {
    if (enableDebugging) {
      print('DSEventManager: $message');
    }
  }

  /// Register a new event provider.
  static void registerProvider(
    String name,
    DSEventProvider provider,
    DSEventProviderMetadata metadata,
  ) {
    _registeredProviders[name] = provider;
    _providerMetadata[name] = metadata;
    log('Registered event provider: $name (${metadata.type})');
  }

  /// Get metadata for a provider.
  static DSEventProviderMetadata? getProviderMetadata(String providerName) {
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

  /// Active event provider.
  late DSEventProvider _provider;

  /// Initialize the manager with a specific provider.
  DSEventManager(String providerName) {
    if (!_registeredProviders.containsKey(providerName)) {
      throw DSEventError('Provider not registered: $providerName');
    }
    _provider = _registeredProviders[providerName]!;
    log('Initialized manager with provider: $providerName');
  }

  /// Initialize the provider with configuration.
  Future<void> initialize(Map<String, dynamic> config) async {
    log('Initializing provider with config...');
    await _provider.initialize(config);
  }

  /// Publish an event.
  Future<void> publish(
    String eventType,
    Map<String, dynamic> payload, {
    Map<String, String>? attributes,
  }) {
    log('Publishing event: $eventType');
    return _provider.publish(
      eventType,
      payload,
      attributes: attributes,
    );
  }

  /// Subscribe to an event stream.
  Stream<DSEventMessage> subscribe(
    String subscription, {
    int maxMessages = 10,
    Duration? pollInterval,
  }) {
    log('Subscribing to: $subscription');
    return _provider.subscribe(
      subscription,
      maxMessages: maxMessages,
      pollInterval: pollInterval,
    );
  }

  /// Acknowledge received events.
  Future<void> acknowledge(String subscription, List<String> ackIds) {
    log('Acknowledging ${ackIds.length} events on: $subscription');
    return _provider.acknowledge(subscription, ackIds);
  }

  /// Dispose of the provider.
  Future<void> dispose() {
    log('Disposing event provider...');
    return _provider.dispose();
  }
}
