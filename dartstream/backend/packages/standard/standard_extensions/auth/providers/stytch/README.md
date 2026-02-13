<<<<<<< HEAD
# Stytch Auth Provider for DartStream

A generic authentication provider for DartStream using Stytch.

## Features

- Email/Password authentication
- Session management
- Token management (Mock implementation for development)
- Secure token storage

## Getting Started

### Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  ds_stytch_auth_provider: ^0.0.1
```

### Usage

```dart
import 'package:ds_stytch_auth_provider/ds_stytch_auth_export.dart';

// Initialize provider
final auth = DSStytchAuthProvider();
await auth.initialize({});

// Sign up
await auth.createAccount('user@example.com', 'password');

// Sign in
await auth.signIn('user@example.com', 'password');

// Get current user
final user = await auth.getCurrentUser();
```

## Running the Example

This package includes a complete example application with a backend server and a frontend client.

To run the example:

1. Navigate to the `example` directory:
   ```bash
   cd example
   ```

2. Run the unified launcher script:
   ```powershell
   ./run_demo.ps1
   ```

This will:
- Install dependencies
- Start the Dart backend server
- Serve the static frontend files
- Automatically open your browser to the demo app
=======
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
>>>>>>> origin/development
