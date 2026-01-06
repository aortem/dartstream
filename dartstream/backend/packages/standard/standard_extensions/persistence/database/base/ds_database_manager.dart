import 'ds_database_provider.dart';

/// Database metadata for registered providers
class DSDatabaseProviderMetadata {
  /// Type of database provider (firebase, postgres, mysql, etc.)
  final String type;

  /// Optional region information (e.g., 'us-east1')
  final String? region;

  /// Database identifier/name
  final String databaseId;

  /// Additional provider-specific metadata
  final Map<String, dynamic>? additionalMetadata;

  /// Constructor
  DSDatabaseProviderMetadata({
    required this.type,
    this.region,
    required this.databaseId,
    this.additionalMetadata,
  });
}

/// Central manager for database providers in DartStream
/// Manages registration, access, and lifecycle of database providers
class DSDatabaseManager {
  /// Registry of database providers
  static final Map<String, DSDatabaseProvider> _registeredProviders = {};

  /// Metadata for registered providers
  static final Map<String, DSDatabaseProviderMetadata> _providerMetadata = {};

  /// Enable debug logging
  static bool enableDebugging = false;

  /// Log messages when debugging is enabled
  static void log(String message) {
    if (enableDebugging) {
      print('DSDatabaseManager: $message');
    }
  }

  /// Register a new database provider
  static void registerProvider(
    String name,
    DSDatabaseProvider provider,
    DSDatabaseProviderMetadata metadata,
  ) {
    _registeredProviders[name] = provider;
    _providerMetadata[name] = metadata;
    log('Registered database provider: $name (${metadata.type})');
  }

  /// Get metadata for a provider
  static DSDatabaseProviderMetadata? getProviderMetadata(String providerName) {
    return _providerMetadata[providerName];
  }

  /// Get a list of all registered provider names
  static List<String> getRegisteredProviderNames() {
    return _registeredProviders.keys.toList();
  }

  /// Get a list of providers by type
  static List<String> getProvidersByType(String type) {
    return _providerMetadata.entries
        .where((entry) => entry.value.type == type)
        .map((entry) => entry.key)
        .toList();
  }

  /// Active database provider
  late DSDatabaseProvider _provider;

  /// Initialize the manager with a specific provider
  DSDatabaseManager(String providerName) {
    if (!_registeredProviders.containsKey(providerName)) {
      throw DSDatabaseError('Provider not registered: $providerName');
    }
    _provider = _registeredProviders[providerName]!;
    log('Initialized manager with provider: $providerName');
  }

  /// Initialize the provider with configuration
  Future<void> initialize(Map<String, dynamic> config) async {
    log('Initializing provider with config...');
    await _provider.initialize(config);
  }

  /// Create a document
  Future<String> createDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    log('Creating document in collection: $collection');
    return await _provider.createDocument(collection, data);
  }

  /// Read a document
  Future<Map<String, dynamic>?> readDocument(
    String collection,
    String id,
  ) async {
    log('Reading document from collection: $collection, id: $id');
    return await _provider.readDocument(collection, id);
  }

  /// Update a document
  Future<void> updateDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    log('Updating document in collection: $collection, id: $id');
    await _provider.updateDocument(collection, id, data);
  }

  /// Delete a document
  Future<void> deleteDocument(String collection, String id) async {
    log('Deleting document from collection: $collection, id: $id');
    await _provider.deleteDocument(collection, id);
  }

  /// Query documents
  Future<List<Map<String, dynamic>>> queryDocuments(
    String collection, {
    required Map<String, dynamic> where,
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    log('Querying documents from collection: $collection');
    return await _provider.queryDocuments(
      collection,
      where: where,
      limit: limit,
      orderBy: orderBy,
      descending: descending,
    );
  }

  /// Begin a transaction
  Future<DSTransaction> beginTransaction() async {
    log('Beginning transaction...');
    return await _provider.beginTransaction();
  }

  /// Get the native database client
  dynamic getNativeClient() {
    return _provider.getNativeClient();
  }

  /// Dispose of the provider
  Future<void> dispose() async {
    log('Disposing database provider...');
    await _provider.dispose();
  }
}
