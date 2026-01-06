import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../base/ds_database_provider.dart';
import 'dart:async';
import 'package:logging/logging.dart';

/// Firebase Firestore implementation of the DSDatabaseProvider
/// Integrates DartStream with Google's Firebase Firestore service
class DSFirebaseDatabase implements DSDatabaseProvider {
  /// Firebase Firestore instance
  late FirebaseFirestore _firestore;

  /// Whether the provider has been initialized
  bool _isInitialized = false;

  /// Logger for database operations
  final _logger = Logger('DSFirebaseDatabase');

  /// Initialize the Firestore provider
  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_isInitialized) {
      _logger.info('Firebase Database already initialized');
      return;
    }

    try {
      // Use existing Firestore instance or create a new one
      _firestore = FirebaseFirestore.instance;

      // Apply configuration settings if provided
      if (config.containsKey('settings')) {
        final settings = config['settings'] as Map<String, dynamic>;
        final firestoreSettings = Settings(
          persistenceEnabled: settings['persistenceEnabled'] as bool? ?? true,
          cacheSizeBytes: settings['cacheSizeBytes'] as int?,
        );

        // Apply settings to Firestore instance
        _firestore.settings = firestoreSettings;
      }

      _isInitialized = true;
      _logger.info('Firebase Database initialized successfully');
    } catch (e) {
      _logger.severe('Failed to initialize Firebase database', e);
      throw DSDatabaseError(
        'Failed to initialize Firebase database: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Create a document in Firestore
  @override
  Future<String> createDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    _checkInitialized('createDocument');
    try {
      // Create a document with auto-generated ID
      final docRef = await _firestore.collection(collection).add(data);
      return docRef.id;
    } catch (e) {
      _logger.warning('Error creating document in $collection', e);
      throw _mapFirebaseError(e);
    }
  }

  /// Read a document from Firestore
  @override
  Future<Map<String, dynamic>?> readDocument(
    String collection,
    String id,
  ) async {
    _checkInitialized('readDocument');
    try {
      final docSnapshot = await _firestore.collection(collection).doc(id).get();
      return docSnapshot.exists ? docSnapshot.data() : null;
    } catch (e) {
      _logger.warning('Error reading document $id from $collection', e);
      throw _mapFirebaseError(e);
    }
  }

  /// Update a document in Firestore
  @override
  Future<void> updateDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    _checkInitialized('updateDocument');
    try {
      await _firestore.collection(collection).doc(id).update(data);
    } catch (e) {
      _logger.warning('Error updating document $id in $collection', e);
      throw _mapFirebaseError(e);
    }
  }

  /// Delete a document from Firestore
  @override
  Future<void> deleteDocument(String collection, String id) async {
    _checkInitialized('deleteDocument');
    try {
      await _firestore.collection(collection).doc(id).delete();
    } catch (e) {
      _logger.warning('Error deleting document $id from $collection', e);
      throw _mapFirebaseError(e);
    }
  }

  /// Query documents from Firestore
  @override
  Future<List<Map<String, dynamic>>> queryDocuments(
    String collection, {
    required Map<String, dynamic> where,
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    _checkInitialized('queryDocuments');
    try {
      // Build query with where conditions
      Query query = _firestore.collection(collection);
      query = _buildQueryFromWhereClause(query, where);

      // Apply ordering
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }

      // Apply limit
      if (limit != null) {
        query = query.limit(limit);
      }

      // Execute query
      final querySnapshot = await query.get();

      // Convert to list of maps with document ID included
      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
          .toList();
    } catch (e) {
      _logger.warning('Error querying documents from $collection', e);
      throw _mapFirebaseError(e);
    }
  }

  /// Helper method to build query from where clauses
  Query _buildQueryFromWhereClause(Query query, Map<String, dynamic> where) {
    where.forEach((field, value) {
      if (value is Map &&
          value.containsKey('operator') &&
          value.containsKey('value')) {
        final operator = value['operator'] as String;
        final fieldValue = value['value'];

        // Apply appropriate where clause based on operator
        switch (operator) {
          case '==':
            query = query.where(field, isEqualTo: fieldValue);
            break;
          case '>':
            query = query.where(field, isGreaterThan: fieldValue);
            break;
          case '>=':
            query = query.where(field, isGreaterThanOrEqualTo: fieldValue);
            break;
          case '<':
            query = query.where(field, isLessThan: fieldValue);
            break;
          case '<=':
            query = query.where(field, isLessThanOrEqualTo: fieldValue);
            break;
          case 'array-contains':
            query = query.where(field, arrayContains: fieldValue);
            break;
          case 'in':
            query = query.where(field, whereIn: fieldValue);
            break;
          case 'array-contains-any':
            query = query.where(field, arrayContainsAny: fieldValue);
            break;
          default:
            throw DSDatabaseError('Unsupported query operator: $operator');
        }
      } else {
        query = query.where(field, isEqualTo: value);
      }
    });

    return query;
  }

  /// Begin a transaction in Firestore
  @override
  Future<DSTransaction> beginTransaction() async {
    _checkInitialized('beginTransaction');
    try {
      // Create a transaction wrapper
      return FirebaseTransaction(_firestore);
    } catch (e) {
      _logger.warning('Error beginning transaction', e);
      throw _mapFirebaseError(e);
    }
  }

  /// Get the native Firestore client
  @override
  FirebaseFirestore getNativeClient() {
    _checkInitialized('getNativeClient');
    return _firestore;
  }

  /// Dispose of resources
  @override
  Future<void> dispose() async {
    // No explicit disposal needed for Firestore
    _isInitialized = false;
  }

  /// Check if provider is initialized with context
  void _checkInitialized(String methodName) {
    if (!_isInitialized) {
      throw DSDatabaseError(
        'Firebase Database not initialized. Error occurred in $methodName method.',
      );
    }
  }

  /// Map Firebase exceptions to DSDatabaseError with enhanced context
  DSDatabaseError _mapFirebaseError(dynamic error) {
    if (error is FirebaseException) {
      return DSDatabaseError(
        error.message ?? 'Unknown Firebase error',
        code: error.code,
        originalError: error,
      );
    }
    return DSDatabaseError(
      error.toString(),
      code: 'unknown_firebase_error',
      originalError: error,
    );
  }

  /// Count documents matching criteria (Firebase-specific extension)
  Future<int?> countDocuments(
    String collection, {
    Map<String, dynamic> where = const {},
  }) async {
    _checkInitialized('countDocuments');
    try {
      // Build query with where conditions
      Query query = _firestore.collection(collection);
      query = _buildQueryFromWhereClause(query, where);

      // Execute query and count results
      final querySnapshot = await query.count().get();
      return querySnapshot.count;
    } catch (e) {
      _logger.warning('Error counting documents in $collection', e);
      throw _mapFirebaseError(e);
    }
  }

  /// Create or update a document with specified ID (Firebase-specific extension)
  Future<void> setDocument(
    String collection,
    String id,
    Map<String, dynamic> data, {
    bool merge = true,
  }) async {
    _checkInitialized('setDocument');
    try {
      await _firestore
          .collection(collection)
          .doc(id)
          .set(data, SetOptions(merge: merge));
    } catch (e) {
      _logger.warning('Error setting document $id in $collection', e);
      throw _mapFirebaseError(e);
    }
  }

  /// Batch creates multiple documents (Firebase-specific extension)
  Future<List<String>> createDocuments(
    String collection,
    List<Map<String, dynamic>> dataList,
  ) async {
    _checkInitialized('createDocuments');
    if (dataList.isEmpty) return [];

    try {
      final batch = _firestore.batch();
      final docRefs = <DocumentReference>[];

      // Prepare batch operations
      for (final data in dataList) {
        final docRef = _firestore.collection(collection).doc();
        docRefs.add(docRef);
        batch.set(docRef, data);
      }

      // Commit batch
      await batch.commit();

      // Return document IDs
      return docRefs.map((ref) => ref.id).toList();
    } catch (e) {
      _logger.warning('Error batch creating documents in $collection', e);
      throw _mapFirebaseError(e);
    }
  }

  /// Listen to document changes (Firebase-specific extension)
  Stream<Map<String, dynamic>?> documentStream(String collection, String id) {
    _checkInitialized('documentStream');
    return _firestore
        .collection(collection)
        .doc(id)
        .snapshots()
        .map((snapshot) => snapshot.exists ? snapshot.data() : null);
  }

  /// Listen to query results (Firebase-specific extension)
  Stream<List<Map<String, dynamic>>> queryStream(
    String collection, {
    required Map<String, dynamic> where,
    int? limit,
    String? orderBy,
    bool descending = false,
  }) {
    _checkInitialized('queryStream');

    // Build query with where conditions
    Query query = _firestore.collection(collection);
    query = _buildQueryFromWhereClause(query, where);

    // Apply ordering
    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    // Apply limit
    if (limit != null) {
      query = query.limit(limit);
    }

    // Return stream of query results
    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map(
                (doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>},
              )
              .toList(),
    );
  }
}

/// Firebase implementation of DSTransaction
class FirebaseTransaction implements DSTransaction {
  final FirebaseFirestore _firestore;
  Transaction? _transaction;

  FirebaseTransaction(this._firestore);

  @override
  Future<String> createDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    if (_transaction == null) {
      // Begin transaction if not already started
      return _firestore.runTransaction<String>((transaction) async {
        _transaction = transaction;

        // Create document reference
        final docRef = _firestore.collection(collection).doc();

        // Set document data in transaction
        _transaction!.set(docRef, data);

        return docRef.id;
      });
    } else {
      // Create document reference
      final docRef = _firestore.collection(collection).doc();

      // Set document data in existing transaction
      _transaction!.set(docRef, data);

      return docRef.id;
    }
  }

  @override
  Future<Map<String, dynamic>?> readDocument(
    String collection,
    String id,
  ) async {
    if (_transaction == null) {
      // Begin transaction if not already started
      return _firestore.runTransaction<Map<String, dynamic>?>((
        transaction,
      ) async {
        _transaction = transaction;

        // Get document reference
        final docRef = _firestore.collection(collection).doc(id);

        // Get document snapshot in transaction
        final snapshot = await _transaction!.get(docRef);

        return snapshot.exists ? snapshot.data() as Map<String, dynamic> : null;
      });
    } else {
      // Get document reference
      final docRef = _firestore.collection(collection).doc(id);

      // Get document snapshot in existing transaction
      final snapshot = await _transaction!.get(docRef);

      return snapshot.exists ? snapshot.data() as Map<String, dynamic> : null;
    }
  }

  @override
  Future<void> updateDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    if (_transaction == null) {
      // Begin transaction if not already started
      return _firestore.runTransaction<void>((transaction) async {
        _transaction = transaction;

        // Get document reference
        final docRef = _firestore.collection(collection).doc(id);

        // Update document in transaction
        _transaction!.update(docRef, data);
      });
    } else {
      // Get document reference
      final docRef = _firestore.collection(collection).doc(id);

      // Update document in existing transaction
      _transaction!.update(docRef, data);
    }
  }

  @override
  Future<void> deleteDocument(String collection, String id) async {
    if (_transaction == null) {
      // Begin transaction if not already started
      return _firestore.runTransaction<void>((transaction) async {
        _transaction = transaction;

        // Get document reference
        final docRef = _firestore.collection(collection).doc(id);

        // Delete document in transaction
        _transaction!.delete(docRef);
      });
    } else {
      // Get document reference
      final docRef = _firestore.collection(collection).doc(id);

      // Delete document in existing transaction
      _transaction!.delete(docRef);
    }
  }

  @override
  Future<void> commit() async {
    // Firebase transactions are automatically committed
    // No explicit commit needed
    _transaction = null;
  }

  @override
  Future<void> rollback() async {
    // Firebase transactions don't support explicit rollback
    // Throwing an exception during transaction execution will cause automatic rollback
    throw DSDatabaseError(
      'Manual rollback not supported in Firebase transactions. ' +
          'Transactions are automatically rolled back when an exception occurs.',
    );
  }
}
