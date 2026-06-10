# DartStream Firebase (Firestore) Database Provider

Google Firestore database provider for DartStream using the official `googleapis` client.

## Install

```yaml
dependencies:
  ds_database_base: ^0.0.2
  ds_firebase_database: ^0.0.2
```

## Usage

```dart
import 'package:ds_database_base/ds_database_base.dart';
import 'package:ds_firebase_database/ds_firebase_database_export.dart';

final config = {
  'name': 'firestore',
  'projectId': 'my-project-id',
  'serviceAccountPath': '/path/to/service-account.json',
  'databaseId': '(default)',
};

registerFirebaseDatabaseProvider(config);

final db = DSDatabaseManager('firestore');
await db.initialize(config);

final id = await db.createDocument('users', {'email': 'user@acme.com'});
final user = await db.readDocument('users', id);
```

## Configuration

- `projectId` - Google Cloud project id (required if not in service account JSON).
- `databaseId` - Firestore database id (optional, default `(default)`).
- `serviceAccountPath` - path to a service account JSON file.
- `serviceAccount` - service account JSON map or JSON string.
- `scopes` - list of OAuth scopes (optional).
- `name` - provider registry name (optional, default `firestore`).
- `region` - metadata only (optional).

## Notes

- Queries are performed with `listDocuments` and filtered client-side.
- Transactions queue writes and commit them as a single Firestore transaction.
