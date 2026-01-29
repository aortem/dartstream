import 'dart:math';

import 'package:ds_database_base/ds_database_base.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DSMongoDatabaseProvider implements DSDatabaseProvider {
  bool _initialized = false;
  Db? _db;
  final Random _random = Random.secure();

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_initialized) {
      return;
    }

    final uri = _requireStringFromKeys(
      config,
      ['uri', 'url', 'connectionString'],
    );

    if (uri.startsWith('mongodb+srv://')) {
      _db = await Db.create(uri);
    } else {
      _db = Db(uri);
    }

    final secure = _boolValue(config, 'secure') ??
        _boolValue(config, 'tls') ??
        _boolValue(config, 'ssl') ??
        false;

    await _db!.open(secure: secure);
    _initialized = true;
  }

  @override
  Future<String> createDocument(String collection, Map<String, dynamic> data) async {
    final coll = _collection(collection);
    final id = _extractId(data) ?? _generateId();
    final payload = _sanitizePayload(data);
    payload['_id'] = id;

    await coll.insertOne(payload);
    return id;
  }

  @override
  Future<Map<String, dynamic>?> readDocument(String collection, String id) async {
    final coll = _collection(collection);
    final doc = await coll.findOne({'_id': id});
    if (doc == null) {
      return null;
    }
    return _normalizeDocument(doc);
  }

  @override
  Future<void> updateDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    final coll = _collection(collection);
    final payload = _sanitizePayload(data);
    await coll.updateOne({'_id': id}, {r'$set': payload});
  }

  @override
  Future<void> deleteDocument(String collection, String id) async {
    final coll = _collection(collection);
    await coll.deleteOne({'_id': id});
  }

  @override
  Future<List<Map<String, dynamic>>> queryDocuments(
    String collection, {
    required Map<String, dynamic> where,
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    final coll = _collection(collection);
    final selector = _normalizeFilter(where);
    final docs = await coll.find(selector).toList();
    final results = docs.map(_normalizeDocument).toList();

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
    throw DSDatabaseError('MongoDB transactions are not supported in this provider.');
  }

  @override
  dynamic getNativeClient() {
    return _db;
  }

  @override
  Future<void> dispose() async {
    if (_db != null) {
      await _db!.close();
    }
    _db = null;
    _initialized = false;
  }

  DbCollection _collection(String collection) {
    final db = _requireDb();
    return db.collection(collection);
  }

  Db _requireDb() {
    if (!_initialized || _db == null) {
      throw DSDatabaseError('MongoDB provider is not initialized.');
    }
    return _db!;
  }

  String? _extractId(Map<String, dynamic> data) {
    final raw = data['id'] ?? data['_id'];
    if (raw == null) {
      return null;
    }
    return raw.toString();
  }

  Map<String, dynamic> _sanitizePayload(Map<String, dynamic> data) {
    final payload = Map<String, dynamic>.from(data);
    payload.remove('id');
    payload.remove('_id');
    return payload;
  }

  Map<String, dynamic> _normalizeFilter(Map<String, dynamic> where) {
    final filter = <String, dynamic>{};
    where.forEach((key, value) {
      if (key == 'id') {
        filter['_id'] = value;
      } else {
        filter[key] = value;
      }
    });
    return filter;
  }

  Map<String, dynamic> _normalizeDocument(Map<String, dynamic> doc) {
    final data = Map<String, dynamic>.from(doc);
    final id = data.remove('_id');
    if (id != null) {
      data['id'] = id.toString();
    }
    return data;
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

  String _generateId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final random = _random.nextInt(1 << 32);
    return '${timestamp}_$random';
  }

  String _requireStringFromKeys(Map<String, dynamic> config, List<String> keys) {
    for (final key in keys) {
      final value = config[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    throw ArgumentError('Missing required MongoDB connection string.');
  }

  bool? _boolValue(Map<String, dynamic> config, String key) {
    final value = config[key];
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return value.toLowerCase() == 'true';
    }
    return null;
  }
}
