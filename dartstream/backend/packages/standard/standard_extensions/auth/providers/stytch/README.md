# DartStream Stytch Authentication Provider

A DartStream authentication provider implementing Stytch authentication services.

## Features

- Email/password authentication (mock implementation)
- Token management
- Session handling
- Error mapping
- Event system integration

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  ds_stytch_auth_provider: ^0.0.1-pre
  ds_auth_base: ^0.0.1
```

## Entry-point registration (recommended)

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_stytch_auth_provider/ds_firebase_auth_export.dart';

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

## License

This package is part of the DartStream project and is licensed under the BSD-3
License.
