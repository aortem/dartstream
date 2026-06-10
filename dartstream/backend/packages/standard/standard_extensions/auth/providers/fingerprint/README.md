# DartStream Fingerprint Authentication Provider

## Overview

Fingerprint authentication provider for DartStream using the
`fingerprint_dart_auth_sdk`.

## Features

- FingerprintJS payload authentication
- Stateless verification via `visitorId`
- Session and token tracking
- `DSAuthProvider` interface compatibility

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  ds_fingerprint_auth_provider: ^0.0.2
```

## Entry-point registration (recommended)

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_fingerprint_auth_provider/ds_fingerprint_auth_export.dart';

Future<void> main() async {
  registerFingerprintProvider({
    'name': 'fingerprint',
    // 'region': 'us-east-1',
    // 'clientId': 'your-client-id',
  });

  final auth = DSAuthManager('fingerprint');
  await auth.initialize({
    // 'region': 'us-east-1',
    // 'clientId': 'your-client-id',
  });
}
```

## Usage

```dart
await auth.signIn('user@example.com', fingerprintPayloadJson);
final user = await auth.getCurrentUser();
print('Signed in as: ${user.email}');

await auth.signOut();
```

## Configuration

The provider expects FingerprintJS payloads as the authentication token. It does
not support refresh tokens.

## License

See `LICENSE` for details.
