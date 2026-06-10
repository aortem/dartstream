# DartStream S3-Compatible Storage Provider

S3-compatible storage provider for DartStream (AWS S3, MinIO, Cloudflare R2, DigitalOcean Spaces).

## Install

```yaml
dependencies:
  ds_storage_base: ^0.0.1
  ds_aws_storage_provider: ^0.0.2
```

## Usage

```dart
import 'package:ds_storage_base/ds_storage_base_export.dart';
import 'package:ds_aws_storage_provider/ds_storage_aws_export.dart';

final config = {
  'name': 's3',
  'endPoint': 's3.amazonaws.com',
  'accessKey': 'YOUR_ACCESS_KEY',
  'secretKey': 'YOUR_SECRET_KEY',
  'bucket': 'my-bucket',
  'useSSL': true,
};

registerAwsStorageProvider(config);

final storage = DSStorageManager('s3');
await storage.initialize(config);

await storage.uploadFile('avatars/user.png', bytes);
final signed = await storage.getSignedUrl('avatars/user.png');
```

## Configuration

- `endPoint` / `endpoint` / `host` (required)
- `accessKey`, `secretKey` (required)
- `bucket` (optional if you pass `bucket/object` paths)
- `useSSL` / `ssl` / `tls` (optional, default true)
- `port` (optional)
- `region` (optional)
- `pathStyle` (optional, defaults to true for non-AWS endpoints)
- `publicUrl` / `baseUrl` (optional)

## Notes

- Provider name defaults to `s3`.
- If no default bucket is configured, pass `bucket/object` as the path.
