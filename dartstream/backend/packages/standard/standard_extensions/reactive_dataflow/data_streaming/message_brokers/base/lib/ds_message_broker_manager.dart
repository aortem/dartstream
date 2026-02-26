import 'ds_message_broker_provider.dart';

/// Metadata for registered message broker providers.
class DSMessageBrokerProviderMetadata {
  /// Provider type (e.g., pubsub).
  final String type;

  /// Optional vendor name (e.g., gcp).
  final String? vendor;

  /// Optional region information.
  final String? region;

  /// Optional project identifier.
  final String? projectId;

  /// Additional provider-specific metadata.
  final Map<String, dynamic>? additionalMetadata;

  /// Constructor.
  DSMessageBrokerProviderMetadata({
    required this.type,
    this.vendor,
    this.region,
    this.projectId,
    this.additionalMetadata,
  });
}

/// Central manager for message broker providers in DartStream.
class DSMessageBrokerManager {
  /// Registry of message broker providers.
  static final Map<String, DSMessageBrokerProvider> _registeredProviders = {};

  /// Metadata for registered providers.
  static final Map<String, DSMessageBrokerProviderMetadata> _providerMetadata = {};

  /// Enable debug logging.
  static bool enableDebugging = false;

  /// Log messages when debugging is enabled.
  static void log(String message) {
    if (enableDebugging) {
      print('DSMessageBrokerManager: $message');
    }
  }

  /// Register a new message broker provider.
  static void registerProvider(
    String name,
    DSMessageBrokerProvider provider,
    DSMessageBrokerProviderMetadata metadata,
  ) {
    _registeredProviders[name] = provider;
    _providerMetadata[name] = metadata;
    log('Registered message broker provider: $name (${metadata.type})');
  }

  /// Get metadata for a provider.
  static DSMessageBrokerProviderMetadata? getProviderMetadata(
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

  /// Active message broker provider.
  late DSMessageBrokerProvider _provider;

  /// Initialize the manager with a specific provider.
  DSMessageBrokerManager(String providerName) {
    if (!_registeredProviders.containsKey(providerName)) {
      throw DSMessageBrokerError('Provider not registered: $providerName');
    }
    _provider = _registeredProviders[providerName]!;
    log('Initialized manager with provider: $providerName');
  }

  /// Initialize the provider with configuration.
  Future<void> initialize(Map<String, dynamic> config) async {
    log('Initializing provider with config...');
    await _provider.initialize(config);
  }

  /// Publish a message to a topic.
  Future<void> publish(
    String topic,
    String payload, {
    Map<String, String>? attributes,
  }) {
    log('Publishing message to topic: $topic');
    return _provider.publish(topic, payload, attributes: attributes);
  }

  /// Subscribe to a subscription stream.
  Stream<DSMessageBrokerMessage> subscribe(
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

  /// Acknowledge received messages.
  Future<void> acknowledge(String subscription, List<String> ackIds) {
    log('Acknowledging ${ackIds.length} messages on: $subscription');
    return _provider.acknowledge(subscription, ackIds);
  }

  /// Dispose of the provider.
  Future<void> dispose() {
    log('Disposing message broker provider...');
    return _provider.dispose();
  }

  static Object? getProvider(String s) {}
}
