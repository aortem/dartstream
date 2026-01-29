import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:ds_database_base/ds_database_base_export.dart';
import 'package:googleapis/firestore/v1.dart' as firestore;
import 'package:googleapis_auth/auth_io.dart';

class DSFirebaseDatabaseProvider implements DSDatabaseProvider {
  bool _initialized = false;
  firestore.FirestoreApi? _api;
  AutoRefreshingAuthClient? _client;
  late String _projectId;
  String _databaseId = '(default)';
  final Random _random = Random.secure();

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_initialized) {
      return;
    }

    final serviceAccount = _loadServiceAccount(config);
    final credentials = ServiceAccountCredentials.fromJson(serviceAccount);

    _projectId =
        _stringFromConfig(config, 'projectId') ??
        _stringFromMap(serviceAccount, 'project_id') ??
        _stringFromConfig(config, 'project') ??
        '';

    if (_projectId.isEmpty) {
      throw ArgumentError('Missing required config: projectId');
    }

    _databaseId = _stringFromConfig(config, 'databaseId') ??
        _stringFromConfig(config, 'database') ??
        '(default)';

    final scopes = _scopesFromConfig(config) ??
        [firestore.FirestoreApi.datastoreScope];

    _client = await clientViaServiceAccount(credentials, scopes);
    _api = firestore.FirestoreApi(_client!);
    _initialized = true;
  }

  @override
  Future<String> createDocument(String collection, Map<String, dynamic> data) async {
    final documents = _documents;
    final collectionId = _sanitizeCollection(collection);
    final id = _extractId(data) ?? _generateId();

    final document = firestore.Document(
      fields: _encodeFields(data),
    );

    await documents.createDocument(
      document,
      _documentsParent,
      collectionId,
      documentId: id,
    );

    return id;
  }

  @override
  Future<Map<String, dynamic>?> readDocument(String collection, String id) async {
    final documents = _documents;
    final name = _documentPath(collection, id);

    try {
      final doc = await documents.get(name);
      return _decodeDocument(doc, id: id);
    } on firestore.DetailedApiRequestError catch (error) {
      if (error.status == 404) {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<void> updateDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    final documents = _documents;
    final name = _documentPath(collection, id);
    final fields = _encodeFields(data);

    final document = firestore.Document(
      name: name,
      fields: fields,
    );

    await documents.patch(
      document,
      name,
      updateMask_fieldPaths: fields.keys.toList(),
    );
  }

  @override
  Future<void> deleteDocument(String collection, String id) async {
    final documents = _documents;
    final name = _documentPath(collection, id);
    await documents.delete(name);
  }

  @override
  Future<List<Map<String, dynamic>>> queryDocuments(
    String collection, {
    required Map<String, dynamic> where,
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    final documents = _documents;
    final collectionId = _sanitizeCollection(collection);

    final response = await documents.listDocuments(
      _documentsParent,
      collectionId,
      pageSize: limit != null && limit > 0 ? limit : null,
    );

    final docs = response.documents ?? [];
    final results = <Map<String, dynamic>>[];

    for (final doc in docs) {
      final decoded = _decodeDocument(doc);
      if (_matchesWhere(decoded, where)) {
        results.add(decoded);
      }
    }

    final orderField = orderBy?.trim();
    if (orderField != null && orderField.isNotEmpty) {
      results.sort((a, b) {
        final comparison = _compareValues(a[orderField], b[orderField]);
        return descending ? -comparison : comparison;
      });
    }

    if (limit != null && limit > 0 && results.length > limit) {
      return results.take(limit).toList();
    }

    return results;
  }

  @override
  Future<DSTransaction> beginTransaction() async {
    final documents = _documents;
    final response = await documents.beginTransaction(
      firestore.BeginTransactionRequest(),
      _databasePath,
    );

    final transaction = response.transaction;
    if (transaction == null || transaction.isEmpty) {
      throw DSDatabaseError('Firestore transaction token is missing.');
    }

    return _FirestoreTransaction(this, transaction);
  }

  @override
  dynamic getNativeClient() {
    return _api;
  }

  @override
  Future<void> dispose() async {
    _client?.close();
    _client = null;
    _api = null;
    _initialized = false;
  }

  firestore.ProjectsDatabasesDocumentsResource get _documents {
    final api = _requireApi();
    return api.projects.databases.documents;
  }

  firestore.FirestoreApi _requireApi() {
    if (!_initialized || _api == null) {
      throw DSDatabaseError('Firestore provider is not initialized.');
    }
    return _api!;
  }

  String get _databasePath => 'projects/$_projectId/databases/$_databaseId';

  String get _documentsParent => '$_databasePath/documents';

  String _documentPath(String collection, String id) {
    final collectionId = _sanitizeCollection(collection);
    return '$_documentsParent/$collectionId/$id';
  }

  String _sanitizeCollection(String collection) {
    final trimmed = collection.trim();
    if (trimmed.isEmpty) {
      throw DSDatabaseError('Collection name is required.');
    }
    if (trimmed.contains('/')) {
      throw DSDatabaseError('Collection name must not contain "/".');
    }
    return trimmed;
  }

  Map<String, dynamic> _loadServiceAccount(Map<String, dynamic> config) {
    final raw = config['serviceAccount'] ?? config['credentials'];

    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }

    if (raw is String && raw.trim().isNotEmpty) {
      return _loadJsonFromStringOrFile(raw.trim());
    }

    final path = config['serviceAccountPath'] ?? config['credentialsPath'];
    if (path is String && path.trim().isNotEmpty) {
      return _loadJsonFromFile(path.trim());
    }

    throw ArgumentError('Service account credentials are required.');
  }

  Map<String, dynamic> _loadJsonFromStringOrFile(String value) {
    final file = File(value);
    if (file.existsSync()) {
      return _loadJsonFromFile(value);
    }

    final decoded = jsonDecode(value);
    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    throw ArgumentError('Invalid service account JSON.');
  }

  Map<String, dynamic> _loadJsonFromFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      throw ArgumentError('Service account file not found: $path');
    }

    final decoded = jsonDecode(file.readAsStringSync());
    if (decoded is Map) {
      return Map<String, dynamic>.from(decoded);
    }

    throw ArgumentError('Invalid service account JSON file: $path');
  }

  List<String>? _scopesFromConfig(Map<String, dynamic> config) {
    final raw = config['scopes'];
    if (raw is List) {
      return raw.map((value) => value.toString()).toList();
    }
    return null;
  }

  String? _stringFromConfig(Map<String, dynamic> config, String key) {
    final value = config[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }

  String? _stringFromMap(Map<String, dynamic> data, String key) {
    final value = data[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }

  String? _extractId(Map<String, dynamic> data) {
    final raw = data['id'] ?? data['_id'];
    if (raw == null) {
      return null;
    }
    return raw.toString();
  }

  String _generateId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final random = _random.nextInt(1 << 32);
    return '${timestamp}_$random';
  }

  Map<String, firestore.Value> _encodeFields(Map<String, dynamic> data) {
    final fields = <String, firestore.Value>{};
    data.forEach((key, value) {
      if (key == 'id' || key == '_id') {
        return;
      }
      fields[key] = _encodeValue(value);
    });
    return fields;
  }

  firestore.Value _encodeValue(dynamic value) {
    if (value == null) {
      return firestore.Value(nullValue: 'NULL_VALUE');
    }

    if (value is bool) {
      return firestore.Value(booleanValue: value);
    }

    if (value is int) {
      return firestore.Value(integerValue: value.toString());
    }

    if (value is double) {
      return firestore.Value(doubleValue: value);
    }

    if (value is num) {
      return firestore.Value(doubleValue: value.toDouble());
    }

    if (value is String) {
      return firestore.Value(stringValue: value);
    }

    if (value is DateTime) {
      return firestore.Value(timestampValue: value.toUtc().toIso8601String());
    }

    if (value is Map) {
      final fields = <String, firestore.Value>{};
      value.forEach((key, item) {
        fields[key.toString()] = _encodeValue(item);
      });
      return firestore.Value(mapValue: firestore.MapValue(fields: fields));
    }

    if (value is Iterable) {
      final items = value.map(_encodeValue).toList();
      return firestore.Value(arrayValue: firestore.ArrayValue(values: items));
    }

    return firestore.Value(stringValue: value.toString());
  }

  Map<String, dynamic> _decodeDocument(firestore.Document document, {String? id}) {
    final result = <String, dynamic>{};
    final fields = document.fields ?? {};

    fields.forEach((key, value) {
      result[key] = _decodeValue(value);
    });

    final resolvedId = id ?? _extractIdFromName(document.name);
    if (resolvedId != null) {
      result['id'] = resolvedId;
    }

    return result;
  }

  dynamic _decodeValue(firestore.Value value) {
    if (value.nullValue != null) {
      return null;
    }

    if (value.booleanValue != null) {
      return value.booleanValue;
    }

    if (value.integerValue != null) {
      return int.tryParse(value.integerValue!) ?? value.integerValue;
    }

    if (value.doubleValue != null) {
      return value.doubleValue;
    }

    if (value.stringValue != null) {
      return value.stringValue;
    }

    if (value.timestampValue != null) {
      return DateTime.tryParse(value.timestampValue!) ?? value.timestampValue;
    }

    if (value.geoPointValue != null) {
      return {
        'latitude': value.geoPointValue!.latitude,
        'longitude': value.geoPointValue!.longitude,
      };
    }

    if (value.referenceValue != null) {
      return value.referenceValue;
    }

    if (value.bytesValue != null) {
      return value.bytesValue;
    }

    if (value.mapValue != null) {
      final map = <String, dynamic>{};
      final fields = value.mapValue!.fields ?? {};
      fields.forEach((key, val) {
        map[key] = _decodeValue(val);
      });
      return map;
    }

    if (value.arrayValue != null) {
      final values = value.arrayValue!.values ?? [];
      return values.map(_decodeValue).toList();
    }

    return null;
  }

  String? _extractIdFromName(String? name) {
    if (name == null || name.isEmpty) {
      return null;
    }
    final parts = name.split('/');
    return parts.isNotEmpty ? parts.last : null;
  }

  bool _matchesWhere(Map<String, dynamic> document, Map<String, dynamic> where) {
    if (where.isEmpty) {
      return true;
    }

    for (final entry in where.entries) {
      final key = entry.key == '_id' ? 'id' : entry.key;
      if (!document.containsKey(key)) {
        return false;
      }
      if (document[key] != entry.value) {
        return false;
      }
    }

    return true;
  }

  int _compareValues(dynamic a, dynamic b) {
    if (a == null && b == null) return 0;
    if (a == null) return -1;
    if (b == null) return 1;

    if (a is num && b is num) {
      return a.compareTo(b);
    }
    if (a is DateTime && b is DateTime) {
      return a.compareTo(b);
    }
    if (a is String && b is String) {
      return a.compareTo(b);
    }
    if (a is Comparable && b is Comparable) {
      try {
        return a.compareTo(b);
      } catch (_) {}
    }
    return a.toString().compareTo(b.toString());
  }
}

class _FirestoreTransaction implements DSTransaction {
  final DSFirebaseDatabaseProvider _provider;
  final String _transaction;
  final List<firestore.Write> _writes = [];
  bool _closed = false;

  _FirestoreTransaction(this._provider, this._transaction);

  void _ensureOpen() {
    if (_closed) {
      throw DSDatabaseError('Transaction already closed.');
    }
  }

  @override
  Future<String> createDocument(String collection, Map<String, dynamic> data) async {
    _ensureOpen();
    final id = _provider._extractId(data) ?? _provider._generateId();
    final name = _provider._documentPath(collection, id);

    final document = firestore.Document(
      name: name,
      fields: _provider._encodeFields(data),
    );

    _writes.add(
      firestore.Write(
        update: document,
        currentDocument: firestore.Precondition(exists: false),
      ),
    );

    return id;
  }

  @override
  Future<Map<String, dynamic>?> readDocument(String collection, String id) async {
    _ensureOpen();
    final name = _provider._documentPath(collection, id);
    final doc = await _provider._documents.get(name, transaction: _transaction);
    return _provider._decodeDocument(doc, id: id);
  }

  @override
  Future<void> updateDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    _ensureOpen();
    final name = _provider._documentPath(collection, id);
    final fields = _provider._encodeFields(data);

    final document = firestore.Document(
      name: name,
      fields: fields,
    );

    _writes.add(
      firestore.Write(
        update: document,
        updateMask: firestore.DocumentMask(fieldPaths: fields.keys.toList()),
      ),
    );
  }

  @override
  Future<void> deleteDocument(String collection, String id) async {
    _ensureOpen();
    final name = _provider._documentPath(collection, id);
    _writes.add(firestore.Write(delete: name));
  }

  @override
  Future<void> commit() async {
    _ensureOpen();
    await _provider._documents.commit(
      firestore.CommitRequest(
        transaction: _transaction,
        writes: _writes,
      ),
      _provider._databasePath,
    );
    _closed = true;
  }

  @override
  Future<void> rollback() async {
    if (_closed) {
      return;
    }
    await _provider._documents.rollback(
      firestore.RollbackRequest(transaction: _transaction),
      _provider._databasePath,
    );
    _closed = true;
  }
}
