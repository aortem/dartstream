# DartStream Firebase Authentication Provider

## Overview

Firebase authentication provider for DartStream using the Firebase Admin Auth SDK.

## Features

- Email/password authentication
- Token management
- Session handling
- Error mapping
- Lifecycle hooks

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  ds_firebase_auth_provider: ^0.0.2
```

## Entry-point registration (recommended)

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_firebase_auth_provider/ds_firebase_auth_export.dart';

Future<void> main() async {
  registerFirebaseProvider({
    'name': 'firebase',
    'projectId': 'your-project-id',
    'privateKeyPath': 'path/to/service-account.json',
    'apiKey': 'your-api-key',
  });

  final auth = DSAuthManager('firebase');
  await auth.initialize({
    'projectId': 'your-project-id',
    'privateKeyPath': 'path/to/service-account.json',
    'apiKey': 'your-api-key',
  });
}
```

## Configuration

Required configuration keys:

- `projectId`
- `privateKeyPath`
- `apiKey`

## Usage

```dart
await auth.signIn('user@example.com', 'password');
final user = await auth.getCurrentUser();
print('Signed in as: ${user.email}');

await auth.signOut();
```

## Running the Example

```powershell
./example/run_demo.ps1
```

## Testing

```bash
dart test
```

## License

See `LICENSE` for details.
