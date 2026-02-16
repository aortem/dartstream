import 'ds_logging_provider.dart';

/// Metadata for registered logging providers
class DSLoggingProviderMetadata {
  /// e.g. 'console', 'stackdriver', etc.
  final String type;

  /// Optional region or environment
  final String? region;

  /// Additional provider-specific settings
  final Map<String, dynamic>? additionalMetadata;

  DSLoggingProviderMetadata({
    required this.type,
    this.region,
    this.additionalMetadata,
  });
}

/// Central manager for logging providers in DartStream
class DSLoggingManager {
  static final Map<String, DSLoggingProvider> _registeredProviders = {};
  static final Map<String, DSLoggingProviderMetadata> _providerMetadata = {};
  static bool enableDebugging = false;

  static void _debugLog(String message) {
    if (enableDebugging) print('DSLoggingManager: $message');
  }

  /// Register a new logging provider
  static void registerProvider(
    String name,
    DSLoggingProvider provider,
    DSLoggingProviderMetadata metadata,
  ) {
    _registeredProviders[name] = provider;
    _providerMetadata[name] = metadata;
    _debugLog('Registered logging provider: $name (${metadata.type})');
  }

  /// Get all registered provider names
  static List<String> getRegisteredProviderNames() =>
      _registeredProviders.keys.toList();

  /// Get metadata for a specific provider
  static DSLoggingProviderMetadata? getProviderMetadata(String name) =>
      _providerMetadata[name];

  late final DSLoggingProvider _provider;

  /// Initialize the manager with one of the registered providers
  DSLoggingManager(String providerName) {
    if (!_registeredProviders.containsKey(providerName)) {
      throw ArgumentError('Logging provider not registered: $providerName');
    }
    _provider = _registeredProviders[providerName]!;
    _debugLog('Initialized manager with provider: $providerName');
  }

  Future<void> initialize(Map<String, dynamic> config) async {
    _debugLog('Initializing logging provider...');
    await _provider.initialize(config);
  }

  void info(String message, {Map<String, dynamic>? context}) {
    _debugLog('INFO: $message');
    _provider.info(message, context: context);
  }

  void warn(String message, {Map<String, dynamic>? context}) {
    _debugLog('WARN: $message');
    _provider.warn(message, context: context);
  }

  void error(
    String message, {
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? context,
  }) {
    _debugLog('ERROR: $message');
    _provider.error(
      message,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  Future<void> flush() => _provider.flush();

  Future<void> dispose() => _provider.dispose();
}
