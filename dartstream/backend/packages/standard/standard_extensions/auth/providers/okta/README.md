# DartStream Okta Authentication Provider

## Overview

This is a mock Okta authentication provider for DartStream. It implements the
`DSAuthProvider` interface without calling external Okta services, making it
open-source safe and suitable for local development and demos.

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  ds_okta_auth_provider: ^0.0.4
```

## Entry-point registration (recommended)

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_okta_auth_provider/ds_okta_auth_export.dart';

Future<void> main() async {
  registerOktaProvider({
    'name': 'okta',
    // 'region': 'us-east-1',
    // 'clientId': 'your-client-id',
  });

  final auth = DSAuthManager('okta');
  await auth.initialize({
    'clientId': 'your-client-id',
    'issuer': 'https://dev-12345.okta.com',
    'clientSecret': 'your-client-secret',
    'redirectUri': 'http://localhost:3000/callback',
  });
}
```

## Configuration

Required configuration keys:

- `clientId`
- `issuer`
- `clientSecret`
- `redirectUri`

Example:

```dart
await auth.initialize({
  'clientId': 'your-client-id',
  'issuer': 'https://dev-12345.okta.com',
  'clientSecret': 'your-client-secret',
  'redirectUri': 'http://localhost:3000/callback',
});
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

### Token Management

```dart
final isValid = await auth.verifyToken();
if (isValid) {
  print('Token is valid');
}

final newToken = await auth.refreshToken('current-refresh-token');
print('New access token: $newToken');
```

## Okta-Specific Methods

```dart
final provider = auth._provider as DSOktaAuthProvider;

await provider.enableMFA('sms');
await provider.disableMFA();

final groups = await provider.getUserGroups('userId');
await provider.assignUserToGroup('userId', 'Admins');
await provider.removeUserFromGroup('userId', 'Admins');

await provider.resetPassword('user@example.com');
final logs = await provider.getAuditLogs('userId');
```

## Features

- User authentication (sign in/sign out)
- Account creation
- Token management (verification and refresh)
- Multi-factor authentication (MFA)
- Group management
- User retrieval by ID
- Password reset
- Audit logs
- Custom user attributes
- Lifecycle hooks (onLoginSuccess, onLogout)

## Testing

```bash
dart test
```

## Mock Implementation

This provider is currently a mock implementation for development and testing
purposes. It simulates Okta authentication behavior without making actual API
calls. In production, replace this with a real Okta SDK integration.

## License

See `LICENSE` for details.
