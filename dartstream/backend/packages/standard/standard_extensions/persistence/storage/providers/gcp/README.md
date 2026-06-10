# DartStream GCS Storage Provider

Google Cloud Storage provider for DartStream using the official `googleapis` client.

## Install

```yaml
dependencies:
  ds_storage_base: ^0.0.1
  ds_gcp_storage_provider: ^0.0.2
```

## Usage

```dart
import 'package:ds_storage_base/ds_storage_base_export.dart';
import 'package:ds_gcp_storage_provider/ds_storage_gcp_export.dart';

final config = {
  'name': 'gcs',
  'bucket': 'my-gcs-bucket',
  'serviceAccountPath': '/path/to/service-account.json',
};

registerGcpStorageProvider(config);

final storage = DSStorageManager('gcs');
await storage.initialize(config);

await storage.uploadFile('avatars/user.png', bytes);
final signed = await storage.getSignedUrl('avatars/user.png');
```

## Configuration

- `bucket` (optional if you pass `bucket/object` paths)
- `serviceAccountPath` or `serviceAccount` (required)
- `scopes` (optional)
- `publicUrl` / `baseUrl` (optional)
- `name` (optional, default `gcs`)

## Notes

- Signed URLs use an OAuth access token and expire with the token lifetime.
- If no default bucket is configured, pass `bucket/object` as the path.
