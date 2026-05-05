# DartStream Azure Blob Storage Provider

Azure Blob Storage provider for DartStream.

## Install

```yaml
dependencies:
  ds_storage_base: ^0.0.1
  ds_azure_storage_provider: ^0.0.1
```

## Usage

```dart
import 'package:ds_storage_base/ds_storage_base_export.dart';
import 'package:ds_azure_storage_provider/ds_storage_azure_export.dart';

final config = {
  'name': 'azure_blob',
  'accountName': 'my-account',
  'accountKey': 'BASE64_STORAGE_ACCOUNT_KEY',
  'container': 'uploads',
};

registerAzureStorageProvider(config);

final storage = DSStorageManager('azure_blob');
await storage.initialize(config);

await storage.uploadFile('avatars/user.png', bytes);
final signed = await storage.getSignedUrl('avatars/user.png');
```

## Configuration

- `accountName` / `account_name` (required)
- `accountKey` / `account_key` (required, base64-encoded storage account key)
- `container` / `defaultContainer` (optional if you pass `container/blob` paths)
- `useHttps` / `https` / `ssl` (optional, default true)
- `endpointSuffix` (optional, default `core.windows.net`)
- `publicUrl` / `baseUrl` (optional)
- `name` (optional, default `azure_blob`)

## Notes

- If no default container is configured, pass `container/blob` as the path.
- Signed URLs are generated as read-only SAS URLs.
