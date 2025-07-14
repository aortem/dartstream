import 'ds_storage_provider.dart';

/// Metadata for registered storage providers
class DSStorageProviderMetadata {
  final String type; // e.g. 's3', 'gcs'
  final String? region; // e.g. 'us-west-2'
  final Map<String, dynamic>? additionalMetadata;

  DSStorageProviderMetadata({
    required this.type,
    this.region,
    this.additionalMetadata,
  });
}

/// Central manager for storage providers in DartStream
class DSStorageManager {
  static final Map<String, DSStorageProvider> _registeredProviders = {};
  static final Map<String, DSStorageProviderMetadata> _providerMetadata = {};
  static bool enableDebugging = false;

  static void _debugLog(String message) {
    if (enableDebugging) print('DSStorageManager: $message');
  }

  /// Register a new storage provider
  static void registerProvider(
    String name,
    DSStorageProvider provider,
    DSStorageProviderMetadata metadata,
  ) {
    _registeredProviders[name] = provider;
    _providerMetadata[name] = metadata;
    _debugLog('Registered storage provider: $name (${metadata.type})');
  }

  /// Get all registered provider names
  static List<String> getRegisteredProviderNames() =>
      _registeredProviders.keys.toList();

  /// Get metadata for a specific provider
  static DSStorageProviderMetadata? getProviderMetadata(String name) =>
      _providerMetadata[name];

  late final DSStorageProvider _provider;

  /// Initialize the manager with one of the registered providers
  DSStorageManager(String providerName) {
    if (!_registeredProviders.containsKey(providerName)) {
      throw ArgumentError('Storage provider not registered: $providerName');
    }
    _provider = _registeredProviders[providerName]!;
    _debugLog('Initialized manager with provider: $providerName');
  }

  Future<void> initialize(Map<String, dynamic> config) async {
    _debugLog('Initializing storage provider...');
    await _provider.initialize(config);
  }

  Future<String> uploadFile(
    String path,
    List<int> data, {
    Map<String, dynamic>? metadata,
  }) async {
    _debugLog('Uploading file to: $path');
    return await _provider.uploadFile(path, data, metadata: metadata);
  }

  Future<List<int>> downloadFile(String path) async {
    _debugLog('Downloading file from: $path');
    return await _provider.downloadFile(path);
  }

  Future<void> deleteFile(String path) async {
    _debugLog('Deleting file at: $path');
    await _provider.deleteFile(path);
  }

  Future<List<String>> listFiles(String path, {bool recursive = false}) async {
    _debugLog('Listing files at: $path');
    return await _provider.listFiles(path, recursive: recursive);
  }

  Future<String> getSignedUrl(String path, {Duration? expiry}) async {
    _debugLog('Getting signed URL for: $path');
    return await _provider.getSignedUrl(path, expiry: expiry);
  }

  Future<void> dispose() async {
    _debugLog('Disposing storage provider...');
    await _provider.dispose();
  }
}
