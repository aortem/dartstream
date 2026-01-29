# DartStream PostgreSQL Database Provider

PostgreSQL database provider for DartStream. Documents are stored in per-collection tables with JSONB payloads.

## Install

```yaml
dependencies:
  ds_database_base: ^0.0.2
  ds_postgres_database: ^0.0.1
```

## Usage

```dart
import 'package:ds_database_base/ds_database_base.dart';
import 'package:ds_postgres_database/ds_postgres_database_export.dart';

final config = {
  'name': 'postgres',
  'host': 'localhost',
  'port': 5432,
  'database': 'dartstream',
  'username': 'postgres',
  'password': 'secret',
  'sslMode': 'disable',
};

registerPostgresDatabaseProvider(config);

final db = DSDatabaseManager('postgres');
await db.initialize(config);

final id = await db.createDocument('users', {'email': 'user@acme.com'});
final user = await db.readDocument('users', id);
```

## Configuration

- `url` / `connectionString` - full PostgreSQL connection string.
- `host`, `port`, `database`, `username`, `password` - used when no connection string is provided.
- `sslMode` - `disable`, `require`, or `verifyFull` (optional).
- `name` - provider registry name (optional, default `postgres`).
- `databaseId` - metadata only (optional).
- `region` - metadata only (optional).

## Notes

- Collection names must use letters, numbers, and underscores, and start with a letter or underscore.
- Queries support simple equality filters mapped to JSONB containment.
