import 'dart:math';

import 'package:ds_database_base/ds_database_base_export.dart';
import 'package:postgres/postgres.dart';

class DSPostgresDatabaseProvider implements DSDatabaseProvider {
  bool _initialized = false;
  Connection? _connection;
  final Random _random = Random.secure();

  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_initialized) {
      return;
    }

    _connection = await _openConnection(config);
    _initialized = true;
  }

  @override
  Future<String> createDocument(String collection, Map<String, dynamic> data) async {
    final connection = _requireConnection();
    await _ensureCollection(collection);

    final id = _extractId(data) ?? _generateId();
    final payload = _sanitizePayload(data);

    final sql = Sql('INSERT INTO ${_tableName(collection)} (id, data) VALUES ($1, $2)');
    await connection.execute(
      sql,
      parameters: [
        id,
        TypedValue(Type.jsonb, payload),
      ],
    );

    return id;
  }

  @override
  Future<Map<String, dynamic>?> readDocument(String collection, String id) async {
    final connection = _requireConnection();
    await _ensureCollection(collection);

    final sql = Sql('SELECT data FROM ${_tableName(collection)} WHERE id = $1');
    final result = await connection.execute(sql, parameters: [id]);
    if (result.isEmpty) {
      return null;
    }

    final row = result.first;
    final data = _coerceMap(row[0]);
    return {
      ...data,
      'id': id,
    };
  }

  @override
  Future<void> updateDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    final connection = _requireConnection();
    await _ensureCollection(collection);

    final payload = _sanitizePayload(data);
    final sql = Sql('UPDATE ${_tableName(collection)} SET data = $1 WHERE id = $2');

    await connection.execute(
      sql,
      parameters: [
        TypedValue(Type.jsonb, payload),
        id,
      ],
    );
  }

  @override
  Future<void> deleteDocument(String collection, String id) async {
    final connection = _requireConnection();
    await _ensureCollection(collection);

    final sql = Sql('DELETE FROM ${_tableName(collection)} WHERE id = $1');
    await connection.execute(sql, parameters: [id]);
  }

  @override
  Future<List<Map<String, dynamic>>> queryDocuments(
    String collection, {
    required Map<String, dynamic> where,
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    final connection = _requireConnection();
    await _ensureCollection(collection);

    final buffer = StringBuffer('SELECT id, data FROM ${_tableName(collection)}');
    final parameters = <Object?>[];

    if (where.isNotEmpty) {
      parameters.add(TypedValue(Type.jsonb, where));
      buffer.write(' WHERE data @> \$${parameters.length}');
    }

    final safeOrderBy = _sanitizeField(orderBy);
    if (safeOrderBy != null) {
      buffer.write(" ORDER BY data->>'$safeOrderBy' ${descending ? 'DESC' : 'ASC'}");
    }

    if (limit != null && limit > 0) {
      buffer.write(' LIMIT $limit');
    }

    final result = await connection.execute(
      Sql(buffer.toString()),
      parameters: parameters,
    );

    return result.map((row) {
      final id = row[0]?.toString() ?? '';
      final data = _coerceMap(row[1]);
      return {
        ...data,
        'id': id,
      };
    }).toList();
  }

  @override
  Future<DSTransaction> beginTransaction() async {
    final connection = _requireConnection();
    await connection.execute('BEGIN');
    return _PostgresTransaction(this);
  }

  @override
  dynamic getNativeClient() {
    return _connection;
  }

  @override
  Future<void> dispose() async {
    if (_connection != null) {
      await _connection!.close();
    }
    _connection = null;
    _initialized = false;
  }

  Connection _requireConnection() {
    if (!_initialized || _connection == null) {
      throw DSDatabaseError('PostgreSQL provider is not initialized.');
    }
    return _connection!;
  }

  Future<Connection> _openConnection(Map<String, dynamic> config) async {
    final connectionString = _stringFromKeys(
      config,
      ['url', 'connectionString', 'connectionUrl', 'uri'],
    );
    final sslMode = _sslModeFromConfig(config) ?? SslMode.disable;

    if (connectionString != null) {
      return Connection.openFromUrl(
        connectionString,
        settings: ConnectionSettings(sslMode: sslMode),
      );
    }

    final host = _requireString(config, 'host');
    final database = _requireString(config, 'database');
    final username = _stringFromKeys(config, ['username', 'user']);
    final password = _stringFromKeys(config, ['password', 'pass']);
    final port = _intValue(config, 'port') ?? 5432;

    return Connection.open(
      Endpoint(
        host: host,
        database: database,
        username: _emptyToNull(username),
        password: _emptyToNull(password),
        port: port,
      ),
      settings: ConnectionSettings(sslMode: sslMode),
    );
  }

  Future<void> _ensureCollection(String collection) async {
    final connection = _requireConnection();
    final table = _tableName(collection);
    await connection.execute(
      'CREATE TABLE IF NOT EXISTS $table (id TEXT PRIMARY KEY, data JSONB NOT NULL)',
    );
  }

  String _tableName(String collection) {
    return _sanitizeIdentifier(collection);
  }

  String _sanitizeIdentifier(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw DSDatabaseError('Collection name is required.');
    }

    final regex = RegExp(r'^[A-Za-z_][A-Za-z0-9_]*$');
    if (!regex.hasMatch(trimmed)) {
      throw DSDatabaseError(
        'Invalid collection name "$value". Use letters, numbers, and underscores.',
      );
    }

    return trimmed;
  }

  String? _sanitizeField(String? field) {
    if (field == null) {
      return null;
    }
    final trimmed = field.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final regex = RegExp(r'^[A-Za-z0-9_]+$');
    if (!regex.hasMatch(trimmed)) {
      throw DSDatabaseError(
        'Invalid orderBy field "$field". Use letters, numbers, and underscores.',
      );
    }

    return trimmed;
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

  Map<String, dynamic> _coerceMap(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.map(
        (key, val) => MapEntry(key.toString(), val),
      );
    }
    return {};
  }

  String _generateId() {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final random = _random.nextInt(1 << 32);
    return '${timestamp}_$random';
  }

  String _requireString(Map<String, dynamic> config, String key) {
    final value = config[key];
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    throw ArgumentError('Missing required config: $key');
  }

  String? _stringFromKeys(Map<String, dynamic> config, List<String> keys) {
    for (final key in keys) {
      final value = config[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  int? _intValue(Map<String, dynamic> config, String key) {
    final value = config[key];
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  String? _emptyToNull(String? value) {
    if (value == null) {
      return null;
    }
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  SslMode? _sslModeFromConfig(Map<String, dynamic> config) {
    final raw = config['sslMode'];
    if (raw is SslMode) {
      return raw;
    }
    if (raw is String) {
      switch (raw.trim().toLowerCase()) {
        case 'disable':
          return SslMode.disable;
        case 'require':
          return SslMode.require;
        case 'verifyfull':
        case 'verify_full':
        case 'verify-full':
          return SslMode.verifyFull;
      }
    }

    final ssl = config['ssl'];
    if (ssl is bool) {
      return ssl ? SslMode.require : SslMode.disable;
    }

    return null;
  }
}

class _PostgresTransaction implements DSTransaction {
  final DSPostgresDatabaseProvider _provider;
  bool _closed = false;

  _PostgresTransaction(this._provider);

  void _ensureOpen() {
    if (_closed) {
      throw DSDatabaseError('Transaction already closed.');
    }
  }

  @override
  Future<String> createDocument(String collection, Map<String, dynamic> data) {
    _ensureOpen();
    return _provider.createDocument(collection, data);
  }

  @override
  Future<Map<String, dynamic>?> readDocument(String collection, String id) {
    _ensureOpen();
    return _provider.readDocument(collection, id);
  }

  @override
  Future<void> updateDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) {
    _ensureOpen();
    return _provider.updateDocument(collection, id, data);
  }

  @override
  Future<void> deleteDocument(String collection, String id) {
    _ensureOpen();
    return _provider.deleteDocument(collection, id);
  }

  @override
  Future<void> commit() async {
    _ensureOpen();
    final connection = _provider.getNativeClient() as Connection?;
    if (connection == null) {
      throw DSDatabaseError('PostgreSQL connection unavailable.');
    }
    await connection.execute('COMMIT');
    _closed = true;
  }

  @override
  Future<void> rollback() async {
    if (_closed) {
      return;
    }
    final connection = _provider.getNativeClient() as Connection?;
    if (connection != null) {
      await connection.execute('ROLLBACK');
    }
    _closed = true;
  }
}
