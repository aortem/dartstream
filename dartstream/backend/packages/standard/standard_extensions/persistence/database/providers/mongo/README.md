# DartStream MongoDB Database Provider

MongoDB database provider for DartStream powered by `mongo_dart`.

## Install

```yaml
dependencies:
  ds_database_base: ^0.0.1
  ds_mongo_database: ^0.0.1
```

## Usage

```dart
import 'package:ds_database_base/ds_database_base.dart';
import 'package:ds_mongo_database/ds_mongo_database_export.dart';

final config = {
  'name': 'mongodb',
  'uri': 'mongodb://localhost:27017/dartstream',
};

registerMongoDatabaseProvider(config);

final db = DSDatabaseManager('mongodb');
await db.initialize(config);

final id = await db.createDocument('users', {'email': 'user@acme.com'});
final user = await db.readDocument('users', id);
```

## Configuration

- `uri` / `url` / `connectionString` - MongoDB connection string.
- `secure` / `tls` / `ssl` - enable TLS (optional).
- `name` - provider registry name (optional, default `mongodb`).
- `databaseId` - metadata only (optional).
- `region` - metadata only (optional).

## Notes

- Documents are stored with `_id` set to the generated string id.
- Queries support simple equality filters and client-side ordering/limits.
- Transactions are not supported in this provider.
