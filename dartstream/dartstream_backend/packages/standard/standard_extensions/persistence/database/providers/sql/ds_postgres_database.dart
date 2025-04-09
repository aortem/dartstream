import 'package:postgres/postgres.dart';
import '../../base/ds_database_provider.dart';

/// PostgreSQL implementation of the DSDatabaseProvider
class DSPostgresDatabase implements DSDatabaseProvider {
  /// PostgreSQL connection instance
  Connection? _connection;

  /// Whether the provider has been initialized
  bool _isInitialized = false;

  /// Schema to use for tables
  String _schema = 'public';

  /// Initialize the PostgreSQL provider
  @override
  Future<void> initialize(Map<String, dynamic> config) async {
    if (_isInitialized) {
      print('PostgreSQL Database already initialized');
      return;
    }

    try {
      // Validate required config parameters
      _validateConfig(config);

      // Extract connection parameters from config
      final host = config['host'] as String? ?? 'localhost';
      final port = config['port'] as int? ?? 5432;
      final database = config['database'] as String;
      final username = config['username'] as String;
      final password = config['password'] as String;

      // Optional schema (defaults to 'public')
      _schema = config['schema'] as String? ?? 'public';

      // Create endpoint for connection
      final endpoint = Endpoint(
        host: host,
        port: port,
        database: database,
        username: username,
        password: password,
      );

      // Open connection
      _connection = await Connection.open(endpoint);

      _isInitialized = true;
      print('PostgreSQL Database initialized successfully');
    } catch (e) {
      throw DSDatabaseError(
        'Failed to initialize PostgreSQL database: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Validate required configuration parameters
  void _validateConfig(Map<String, dynamic> config) {
    if (!config.containsKey('database') || config['database'] is! String) {
      throw DSDatabaseError('Database name is required and must be a string');
    }

    if (!config.containsKey('username') || config['username'] is! String) {
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
  Future<Connection> _getConnection() async {
    _checkInitialized();

    if (_connection == null) {
      throw DSDatabaseError('PostgreSQL connection is null');
    }

    return _connection!;
  }

  /// Create a document (row) in PostgreSQL
  @override
  Future<String> createDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    _validateTableName(collection);
    final conn = await _getConnection();

    try {
      // Generate column names and values for SQL query
      final columns = data.keys.map((k) => '"$k"').join(', ');

      // Use named parameters for postgres package
      final sql = Sql.named(
        'INSERT INTO "$_schema"."$collection" ($columns) VALUES (${data.keys.map((k) => '@$k').join(', ')}) RETURNING id',
      );

      // Execute query
      final result = await conn.execute(sql, parameters: data);

      if (result.isEmpty) {
        throw DSDatabaseError('Failed to create document: No ID returned');
      }

      return result[0][0].toString();
    } catch (e) {
      // Handle connection issues and retry once
      if (_isConnectionIssue(e)) {
        await _reconnect();
        return createDocument(collection, data);
      }
      throw _mapPostgresError(e);
    }
  }

  /// Read a document (row) from PostgreSQL
  @override
  Future<Map<String, dynamic>?> readDocument(
    String collection,
    String id,
  ) async {
    _validateTableName(collection);
    final conn = await _getConnection();

    try {
      // Use named parameters
      final sql = Sql.named(
        'SELECT * FROM "$_schema"."$collection" WHERE id = @id',
      );

      // Execute query
      final result = await conn.execute(sql, parameters: {'id': id});

      if (result.isEmpty) {
        return null;
      }

      // Convert first row to Map
      return result[0].toColumnMap();
    } catch (e) {
      if (_isConnectionIssue(e)) {
        await _reconnect();
        return readDocument(collection, id);
      }
      throw _mapPostgresError(e);
    }
  }

  /// Update a document (row) in PostgreSQL
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
      final setClauses = data.keys.map((key) => '"$key" = @$key').join(', ');

      // Add ID to parameters
      final parameters = Map<String, dynamic>.from(data);
      parameters['id'] = id;

      // Create SQL with named parameters
      final sql = Sql.named(
        'UPDATE "$_schema"."$collection" SET $setClauses WHERE id = @id',
      );

      // Execute query
      await conn.execute(sql, parameters: parameters);
    } catch (e) {
      if (_isConnectionIssue(e)) {
        await _reconnect();
        await updateDocument(collection, id, data);
        return;
      }
      throw _mapPostgresError(e);
    }
  }

  /// Delete a document (row) from PostgreSQL
  @override
  Future<void> deleteDocument(String collection, String id) async {
    _validateTableName(collection);
    final conn = await _getConnection();

    try {
      // Create SQL with named parameters
      final sql = Sql.named(
        'DELETE FROM "$_schema"."$collection" WHERE id = @id',
      );

      // Execute query
      await conn.execute(sql, parameters: {'id': id});
    } catch (e) {
      if (_isConnectionIssue(e)) {
        await _reconnect();
        await deleteDocument(collection, id);
        return;
      }
      throw _mapPostgresError(e);
    }
  }

  /// Query documents (rows) from PostgreSQL
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
      final parameters = <String, dynamic>{};

      if (where.isNotEmpty) {
        final conditions = <String>[];
        int paramIndex = 0;

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
            final paramName = '${field}_$paramIndex';

            // Validate operator to prevent SQL injection
            if (!_isValidOperator(operator)) {
              throw DSDatabaseError('Invalid operator: $operator');
            }

            conditions.add('"$field" $operator @$paramName');
            parameters[paramName] = fieldValue;
          } else {
            final paramName = '${field}_$paramIndex';
            conditions.add('"$field" = @$paramName');
            parameters[paramName] = value;
          }
          paramIndex++;
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

        orderByClause = 'ORDER BY "$orderBy" ${descending ? 'DESC' : 'ASC'}';
      }

      // Build LIMIT clause
      String limitClause = '';
      if (limit != null) {
        limitClause = 'LIMIT $limit';
      }

      // Create full SQL query
      final sqlQuery =
          'SELECT * FROM "$_schema"."$collection" $whereClause $orderByClause $limitClause';
      final sql = Sql.named(sqlQuery);

      // Execute query
      final result = await conn.execute(sql, parameters: parameters);

      // Convert results to list of maps
      return result.map((row) => row.toColumnMap()).toList();
    } catch (e) {
      if (_isConnectionIssue(e)) {
        await _reconnect();
        return queryDocuments(
          collection,
          where: where,
          limit: limit,
          orderBy: orderBy,
          descending: descending,
        );
      }
      throw _mapPostgresError(e);
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

  /// Begin a transaction in PostgreSQL
  @override
  Future<DSTransaction> beginTransaction() async {
    final conn = await _getConnection();

    try {
      // Use a wrapper class that implements our DSTransaction interface
      // but delegates to the Connection for transaction operations
      return PostgresTransaction(conn, _schema);
    } catch (e) {
      if (_isConnectionIssue(e)) {
        await _reconnect();
        return beginTransaction();
      }
      throw _mapPostgresError(e);
    }
  }

  /// Checks if the error is a connection issue
  bool _isConnectionIssue(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    return errorStr.contains('connection') ||
        errorStr.contains('network') ||
        errorStr.contains('timeout') ||
        errorStr.contains('closed');
  }

  /// Reconnect to the database
  Future<void> _reconnect() async {
    try {
      // Create new endpoint based on existing connection info
      final endpoint = Endpoint(
        host: 'localhost', // Default fallback if reconnecting
        database: 'postgres', // Default fallback if reconnecting
        username: 'postgres', // Default fallback if reconnecting
        password: 'postgres', // Default fallback if reconnecting
      );

      _connection = await Connection.open(endpoint);
    } catch (e) {
      throw DSDatabaseError(
        'Failed to reconnect to PostgreSQL database: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Get the native PostgreSQL client
  @override
  dynamic getNativeClient() {
    _checkInitialized();
    return _connection;
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

  /// Check if provider is initialized
  void _checkInitialized() {
    if (!_isInitialized) {
      throw DSDatabaseError('PostgreSQL Database not initialized');
    }
  }

  /// Map PostgreSQL exceptions to DSDatabaseError
  DSDatabaseError _mapPostgresError(dynamic error) {
    return DSDatabaseError(
      error.toString(),
      code: 'postgres_error',
      originalError: error,
    );
  }
}

/// PostgreSQL implementation of DSTransaction using postgres package
class PostgresTransaction implements DSTransaction {
  final Connection _connection;
  final String _schema;
  bool _isActive = true;

  PostgresTransaction(this._connection, this._schema);

  @override
  Future<String> createDocument(
    String collection,
    Map<String, dynamic> data,
  ) async {
    // Validate table name
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(collection)) {
      throw DSDatabaseError('Invalid table name: $collection');
    }

    // Generate column names for SQL query
    final columns = data.keys.map((k) => '"$k"').join(', ');

    // Create SQL with named parameters
    final sql = Sql.named(
      'INSERT INTO "$_schema"."$collection" ($columns) VALUES (${data.keys.map((k) => '@$k').join(', ')}) RETURNING id',
    );

    // Run in transaction
    final result = await _connection.execute(sql, parameters: data);

    if (result.isEmpty) {
      throw DSDatabaseError('Failed to create document: No ID returned');
    }

    return result[0][0].toString();
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

    // Create SQL with named parameters
    final sql = Sql.named(
      'SELECT * FROM "$_schema"."$collection" WHERE id = @id',
    );

    // Run in transaction
    final result = await _connection.execute(sql, parameters: {'id': id});

    if (result.isEmpty) {
      return null;
    }

    // Convert first row to Map
    return result[0].toColumnMap();
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
    final setClauses = data.keys.map((key) => '"$key" = @$key').join(', ');

    // Add ID to parameters
    final parameters = Map<String, dynamic>.from(data);
    parameters['id'] = id;

    // Create SQL with named parameters
    final sql = Sql.named(
      'UPDATE "$_schema"."$collection" SET $setClauses WHERE id = @id',
    );

    // Run in transaction
    await _connection.execute(sql, parameters: parameters);
  }

  @override
  Future<void> deleteDocument(String collection, String id) async {
    // Validate table name
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(collection)) {
      throw DSDatabaseError('Invalid table name: $collection');
    }

    // Create SQL with named parameters
    final sql = Sql.named(
      'DELETE FROM "$_schema"."$collection" WHERE id = @id',
    );

    // Run in transaction
    await _connection.execute(sql, parameters: {'id': id});
  }

  @override
  Future<void> commit() async {
    if (!_isActive) {
      throw DSDatabaseError('Transaction already committed or rolled back');
    }

    await _connection.execute('COMMIT');
    _isActive = false;
  }

  @override
  Future<void> rollback() async {
    if (!_isActive) {
      throw DSDatabaseError('Transaction already committed or rolled back');
    }

    await _connection.execute('ROLLBACK');
    _isActive = false;
  }
}
