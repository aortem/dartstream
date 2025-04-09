import 'package:mysql1/mysql1.dart';
import '../../base/ds_database_provider.dart';

/// MySQL implementation of the DSDatabaseProvider
class DSMySQLDatabase implements DSDatabaseProvider {
  /// MySQL connection instance
  MySqlConnection? _connection;

  /// Connection settings
  late ConnectionSettings _settings;

  /// Whether the provider has been initialized
  bool _isInitialized = false;

  /// Initialize the MySQL provider
  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_isInitialized) {
      print('MySQL Database already initialized');
      return;
    }

    try {
      // Validate required config parameters
      _validateConfig(config);

      // Extract connection parameters from config
      final host = config['host'] as String? ?? 'localhost';
      final port = config['port'] as int? ?? 3306;
      final database = config['database'] as String;
      final username =
          config['user'] as String? ?? config['username'] as String;
      final password = config['password'] as String;

      // Create connection settings
      _settings = ConnectionSettings(
        host: host,
        port: port,
        db: database,
        user: username,
        password: password,
        timeout: Duration(seconds: config['timeout'] as int? ?? 30),
        // Fixed: Renamed 'secure' to 'useSSL' to match ConnectionSettings parameter
        useSSL: config['secure'] as bool? ?? false,
      );

      // Open connection
      _connection = await MySqlConnection.connect(_settings);

      _isInitialized = true;
      print('MySQL Database initialized successfully');
    } catch (e) {
      throw DSDatabaseError(
        'Failed to initialize MySQL database: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Validate required configuration parameters
  void _validateConfig(Map<String, dynamic> config) {
    if (!config.containsKey('database') || config['database'] is! String) {
      throw DSDatabaseError('Database name is required and must be a string');
    }

    if ((!config.containsKey('user') && !config.containsKey('username')) ||
        (config['user'] is! String && config['username'] is! String)) {
      throw DSDatabaseError('Username is required and must be a string');
    }

    if (!config.containsKey('password') || config['password'] is! String) {
      throw DSDatabaseError('Password is required and must be a string');
    }
  }

  /// Validate table name to prevent SQL injection
  void _validateTableName(String name) {
    final valid = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!valid.hasMatch(name)) {
      throw DSDatabaseError('Invalid table name: $name');
    }
  }

  /// Ensure connection is open and available
  Future<MySqlConnection> _getConnection() async {
    _checkInitialized();

    if (_connection == null) {
      _connection = await MySqlConnection.connect(_settings);
    }

    return _connection!;
  }

  /// Create a document (row) in MySQL
  @override
  Future<String> createDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    _validateTableName(collection);
    final conn = await _getConnection();

    try {
      // Generate column names and values for SQL query
      final columns = data.keys.map((k) => '`$k`').join(', ');
      final placeholders = data.keys.map((_) => '?').join(', ');

      // Execute insert
      final result = await conn.query(
        'INSERT INTO `$collection` ($columns) VALUES ($placeholders)',
        data.values.toList(),
      );

      return result.insertId.toString();
    } catch (e) {
      // Handle connection closed error and retry once
      if (_isConnectionClosed(e)) {
        await _reconnect();
        return createDocument(collection, data);
      }
      throw _mapMySQLError(e);
    }
  }

  /// Read a document (row) from MySQL
  @override
  Future<Map<String, dynamic>?> readDocument(
    String collection,
    String id,
  ) async {
    _validateTableName(collection);
    final conn = await _getConnection();

    try {
      final results = await conn.query(
        'SELECT * FROM `$collection` WHERE id = ?',
        [id],
      );

      if (results.isEmpty) {
        return null;
      }

      // Convert from MySQL result to Map
      return _resultRowToMap(results.first);
    } catch (e) {
      if (_isConnectionClosed(e)) {
        await _reconnect();
        return readDocument(collection, id);
      }
      throw _mapMySQLError(e);
    }
  }

  /// Update a document (row) in MySQL
  @override
  Future<void> updateDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    _validateTableName(collection);
    final conn = await _getConnection();

    try {
      // Generate SET clause for SQL query
      final setClauses = data.keys.map((key) => '`$key` = ?').join(', ');

      // Execute update
      await conn.query('UPDATE `$collection` SET $setClauses WHERE id = ?', [
        ...data.values.toList(),
        id,
      ]);
    } catch (e) {
      if (_isConnectionClosed(e)) {
        await _reconnect();
        await updateDocument(collection, id, data);
        return;
      }
      throw _mapMySQLError(e);
    }
  }

  /// Delete a document (row) from MySQL
  @override
  Future<void> deleteDocument(String collection, String id) async {
    _validateTableName(collection);
    final conn = await _getConnection();

    try {
      await conn.query('DELETE FROM `$collection` WHERE id = ?', [id]);
    } catch (e) {
      if (_isConnectionClosed(e)) {
        await _reconnect();
        await deleteDocument(collection, id);
        return;
      }
      throw _mapMySQLError(e);
    }
  }

  /// Query documents (rows) from MySQL
  @override
  Future<List<Map<String, dynamic>>> queryDocuments(
    String collection, {
    required Map<String, dynamic> where,
    int? limit,
    String? orderBy,
    bool descending = false,
  }) async {
    _validateTableName(collection);
    final conn = await _getConnection();

    try {
      // Build WHERE clause and values
      String whereClause = '';
      final whereValues = <dynamic>[];

      if (where.isNotEmpty) {
        final conditions = <String>[];

        where.forEach((field, value) {
          // Validate field name to prevent SQL injection
          if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(field)) {
            throw DSDatabaseError('Invalid field name: $field');
          }

          if (value is Map &&
              value.containsKey('operator') &&
              value.containsKey('value')) {
            final operator = value['operator'] as String;
            final fieldValue = value['value'];

            // Validate operator to prevent SQL injection
            if (!_isValidOperator(operator)) {
              throw DSDatabaseError('Invalid operator: $operator');
            }

            conditions.add('`$field` $operator ?');
            whereValues.add(fieldValue);
          } else {
            conditions.add('`$field` = ?');
            whereValues.add(value);
          }
        });

        whereClause = 'WHERE ${conditions.join(' AND ')}';
      }

      // Build ORDER BY clause
      String orderByClause = '';
      if (orderBy != null) {
        // Validate orderBy to prevent SQL injection
        if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(orderBy)) {
          throw DSDatabaseError('Invalid order by field: $orderBy');
        }

        orderByClause = 'ORDER BY `$orderBy` ${descending ? 'DESC' : 'ASC'}';
      }

      // Build LIMIT clause
      String limitClause = '';
      if (limit != null) {
        limitClause = 'LIMIT $limit';
      }

      // Execute query
      final results = await conn.query(
        'SELECT * FROM `$collection` $whereClause $orderByClause $limitClause',
        whereValues,
      );

      // Convert results to list of maps
      return results.map((row) => _resultRowToMap(row)).toList();
    } catch (e) {
      if (_isConnectionClosed(e)) {
        await _reconnect();
        return queryDocuments(
          collection,
          where: where,
          limit: limit,
          orderBy: orderBy,
          descending: descending,
        );
      }
      throw _mapMySQLError(e);
    }
  }

  /// Check if the operator is valid (to prevent SQL injection)
  bool _isValidOperator(String operator) {
    const validOperators = [
      '=',
      '<',
      '>',
      '<=',
      '>=',
      '<>',
      'LIKE',
      'IN',
      'NOT IN',
      'IS NULL',
      'IS NOT NULL',
    ];
    return validOperators.contains(operator.toUpperCase());
  }

  /// Begin a transaction in MySQL
  @override
  Future<DSTransaction> beginTransaction() async {
    final conn = await _getConnection();

    try {
      // Start a transaction
      await conn.query('START TRANSACTION');

      return MySQLTransaction(conn);
    } catch (e) {
      if (_isConnectionClosed(e)) {
        await _reconnect();
        return beginTransaction();
      }
      throw _mapMySQLError(e);
    }
  }

  /// Checks if the error is a connection closed error
  bool _isConnectionClosed(dynamic error) {
    return error.toString().contains('Connection closed') ||
        error.toString().contains('Connection reset by peer');
  }

  /// Reconnect to the database
  Future<void> _reconnect() async {
    try {
      _connection = await MySqlConnection.connect(_settings);
    } catch (e) {
      throw DSDatabaseError(
        'Failed to reconnect to MySQL database: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Get the native MySQL client
  @override
  MySqlConnection getNativeClient() {
    _checkInitialized();
    return _connection!;
  }

  /// Dispose of resources
  @override
  Future<void> dispose() async {
    if (_isInitialized && _connection != null) {
      await _connection!.close();
      _connection = null;
      _isInitialized = false;
    }
  }

  /// Convert a MySQL result row to a Map
  Map<String, dynamic> _resultRowToMap(ResultRow row) {
    final result = <String, dynamic>{};
    row.fields.forEach((key, value) {
      result[key] = value;
    });
    return result;
  }

  /// Check if provider is initialized
  void _checkInitialized() {
    if (!_isInitialized) {
      throw DSDatabaseError('MySQL Database not initialized');
    }
  }

  /// Map MySQL exceptions to DSDatabaseError
  DSDatabaseError _mapMySQLError(dynamic error) {
    if (error is MySqlException) {
      return DSDatabaseError(
        error.message,
        code: error.errorNumber.toString(),
        originalError: error,
      );
    }
    return DSDatabaseError(error.toString(), originalError: error);
  }
}

/// MySQL implementation of DSTransaction
class MySQLTransaction implements DSTransaction {
  final MySqlConnection _connection;

  MySQLTransaction(this._connection);

  @override
  Future<String> createDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    // Validate table name
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(collection)) {
      throw DSDatabaseError('Invalid table name: $collection');
    }

    // Generate column names and values for SQL query
    final columns = data.keys.map((k) => '`$k`').join(', ');
    final placeholders = data.keys.map((_) => '?').join(', ');

    // Execute insert
    final result = await _connection.query(
      'INSERT INTO `$collection` ($columns) VALUES ($placeholders)',
      data.values.toList(),
    );

    return result.insertId.toString();
  }

  @override
  Future<Map<String, dynamic>?> readDocument(
    String collection,
    String id,
  ) async {
    // Validate table name
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(collection)) {
      throw DSDatabaseError('Invalid table name: $collection');
    }

    final results = await _connection.query(
      'SELECT * FROM `$collection` WHERE id = ?',
      [id],
    );

    if (results.isEmpty) {
      return null;
    }

    // Convert from MySQL result to Map
    final result = <String, dynamic>{};
    final row = results.first;
    row.fields.forEach((key, value) {
      result[key] = value;
    });

    return result;
  }

  @override
  Future<void> updateDocument(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    // Validate table name
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(collection)) {
      throw DSDatabaseError('Invalid table name: $collection');
    }

    // Generate SET clause for SQL query
    final setClauses = data.keys.map((key) => '`$key` = ?').join(', ');

    // Execute update
    await _connection.query(
      'UPDATE `$collection` SET $setClauses WHERE id = ?',
      [...data.values.toList(), id],
    );
  }

  @override
  Future<void> deleteDocument(String collection, String id) async {
    // Validate table name
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(collection)) {
      throw DSDatabaseError('Invalid table name: $collection');
    }

    await _connection.query('DELETE FROM `$collection` WHERE id = ?', [id]);
  }

  @override
  Future<void> commit() async {
    await _connection.query('COMMIT');
  }

  @override
  Future<void> rollback() async {
    await _connection.query('ROLLBACK');
  }
}
