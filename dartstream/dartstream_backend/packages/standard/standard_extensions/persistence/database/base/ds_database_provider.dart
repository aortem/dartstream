/// Database provider interface for DartStream.
/// This abstract class defines the standard interface for all database providers.
abstract class DSDatabaseProvider {
  /// Initialize the database provider with configuration settings
  Future<void> initialize(Map<String, dynamic> config);

  /// Creates a document in the specified collection
  Future<String> createDocument(String collection, Map<String, dynamic> data);

  /// Reads a document from the specified collection by ID
  Future<Map<String, dynamic>?> readDocument(String collection, String id);

  /// Updates a document in the specified collection
  Future<void> updateDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  );

  /// Deletes a document from the specified collection
  Future<void> deleteDocument(String collection, String id);

  /// Queries documents from the specified collection based on criteria
  Future<List<Map<String, dynamic>>> queryDocuments(
    String collection, {
    required Map<String, dynamic> where,
    int? limit,
    String? orderBy,
    bool descending = false,
  });

  /// Begins a transaction
  Future<DSTransaction> beginTransaction();

  /// Gets the native database client for raw operations
  dynamic getNativeClient();

  /// Releases any resources used by the provider
  Future<void> dispose();
}

/// Represents a database transaction
abstract class DSTransaction {
  /// Creates a document within this transaction
  Future<String> createDocument(String collection, Map<String, dynamic> data);

  /// Reads a document within this transaction
  Future<Map<String, dynamic>?> readDocument(String collection, String id);

  /// Updates a document within this transaction
  Future<void> updateDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  );

  /// Deletes a document within this transaction
  Future<void> deleteDocument(String collection, String id);

  /// Commits the transaction
  Future<void> commit();

  /// Rolls back the transaction
  Future<void> rollback();
}

/// Custom exception for handling database errors
class DSDatabaseError implements Exception {
  /// Error message
  final String message;

  /// Error code
  final String code;

  /// Native error object
  final dynamic originalError;

  /// Constructor for database error
  DSDatabaseError(this.message, {this.code = 'unknown', this.originalError});

  @override
  String toString() => 'DSDatabaseError: $message (Code: $code)';
}
