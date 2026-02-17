# DartStream Stytch Authentication Provider

## Overview

This is a mock Stytch authentication provider for DartStream. It implements the
`DSAuthProvider` interface without calling external Stytch services, making it
open-source safe and suitable for local development and demos.

## Features

- Email/password authentication (mock implementation)
- Token management
- Session handling
- Error mapping
- Event hooks

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  ds_stytch_auth_provider: ^0.0.4
```

## Entry-point registration (recommended)

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_stytch_auth_provider/ds_stytch_auth_export.dart';

Future<void> main() async {
  registerStytchProvider({
    'name': 'stytch',
    // 'region': 'us-east-1',
    // 'clientId': 'your-client-id',
  });

  final auth = DSAuthManager('stytch');
  await auth.initialize({
    // 'clientId': 'your-client-id',
    // 'region': 'us-east-1',
  });
}
```

## Usage

### Basic Authentication

```dart
await auth.createAccount(
  'user@example.com',
  'securePassword123',
  displayName: 'John Doe',
);

await auth.signIn('user@example.com', 'securePassword123');
final user = await auth.getCurrentUser();
print('Signed in as: ${user.email}');

await auth.signOut();
```

## Configuration

The mock provider accepts configuration values but does not require them in
development mode. You can still pass standard keys to keep a consistent setup.

```dart
await auth.initialize({
  'clientId': 'your-client-id',
  'region': 'us-east-1',
});
```

## Running the Example

This package includes a complete example app with a backend server and a
frontend client.

1. Navigate to the `example` directory:

```powershell
cd example
```

2. Run the unified launcher script:

```powershell
./run_demo.ps1
```

The server starts on `http://localhost:8082`.

## License

See `LICENSE` for details.
