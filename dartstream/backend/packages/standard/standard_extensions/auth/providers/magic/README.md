# DartStream Magic Authentication Provider

## Overview

Magic authentication provider for DartStream using Magic DID tokens.

## Features

- Passwordless authentication via DID tokens
- Token management
- Session handling
- Error mapping
- Lifecycle hooks

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  ds_magic_auth_provider: ^0.0.3
```

## Entry-point registration (recommended)

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_magic_auth_provider/ds_magic_auth_export.dart';

Future<void> main() async {
  registerMagicProvider({
    'name': 'magic',
    'publishableKey': 'your-magic-publishable-key',
    'secretKey': 'your-magic-secret-key',
  });

  final auth = DSAuthManager('magic');
  await auth.initialize({
    'publishableKey': 'your-magic-publishable-key',
    'secretKey': 'your-magic-secret-key',
  });
}
```

## Usage

```dart
await auth.signIn('user@example.com', didToken);
final user = await auth.getCurrentUser();
print('Signed in as: ${user.email}');

await auth.signOut();
```

## Configuration

Required configuration keys:

- `publishableKey`
- `secretKey`

## Lifecycle Hooks

Override `onLoginSuccess` and `onLogout` in a subclass if you need custom
behavior on authentication events.

## Running the Example App

Run the demo script to start both backend and frontend:

```powershell
./example/run_demo.ps1
```

Or run manually:

1. Backend: `cd example && dart run server.dart`
2. Frontend: `cd example/magic-app && npm run dev`

## License

See `LICENSE` for details.
