import 'ds_websocket_provider.dart';

/// Metadata for registered WebSocket providers.
class DSWebSocketProviderMetadata {
  /// Provider type (e.g., socket_io).
  final String type;

  /// Optional vendor name.
  final String? vendor;

  /// Optional protocol.
  final String? protocol;

  /// Additional provider-specific metadata.
  final Map<String, dynamic>? additionalMetadata;

  /// Constructor.
  DSWebSocketProviderMetadata({
    required this.type,
    this.vendor,
    this.protocol,
    this.additionalMetadata,
  });
}

/// Central manager for WebSocket providers in DartStream.
class DSWebSocketManager {
  /// Registry of WebSocket providers.
  static final Map<String, DSWebSocketProvider> _registeredProviders = {};

  /// Metadata for registered providers.
  static final Map<String, DSWebSocketProviderMetadata> _providerMetadata = {};

  /// Enable debug logging.
  static bool enableDebugging = false;

  /// Log messages when debugging is enabled.
  static void log(String message) {
    if (enableDebugging) {
      print('DSWebSocketManager: $message');
    }
  }

  /// Register a new WebSocket provider.
  static void registerProvider(
    String name,
    DSWebSocketProvider provider,
    DSWebSocketProviderMetadata metadata,
  ) {
    _registeredProviders[name] = provider;
    _providerMetadata[name] = metadata;
    log('Registered WebSocket provider: $name (${metadata.type})');
  }

  /// Get metadata for a provider.
  static DSWebSocketProviderMetadata? getProviderMetadata(String providerName) {
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

  /// Active WebSocket provider.
  late DSWebSocketProvider _provider;

  /// Initialize the manager with a specific provider.
  DSWebSocketManager(String providerName) {
    if (!_registeredProviders.containsKey(providerName)) {
      throw DSWebSocketError('Provider not registered: $providerName');
    }
    _provider = _registeredProviders[providerName]!;
    log('Initialized manager with provider: $providerName');
  }

  /// Connect using the provider.
  Future<void> connect(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? options,
  }) {
    log('Connecting to: $url');
    return _provider.connect(
      url,
      headers: headers,
      options: options,
    );
  }

  /// Register an event handler.
  void on(String event, void Function(dynamic data) handler) {
    log('Registering handler for event: $event');
    _provider.on(event, handler);
  }

  /// Emit an event.
  void emit(String event, dynamic data) {
    log('Emitting event: $event');
    _provider.emit(event, data);
  }

  /// Disconnect the provider.
  Future<void> disconnect() {
    log('Disconnecting provider...');
    return _provider.disconnect();
  }

  /// Dispose of the provider.
  Future<void> dispose() {
    log('Disposing WebSocket provider...');
    return _provider.dispose();
  }
}
