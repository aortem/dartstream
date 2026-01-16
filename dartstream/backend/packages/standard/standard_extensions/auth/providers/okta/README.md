# DartStream Okta Authentication Provider

A DartStream authentication provider for Okta, implementing the `DSAuthProvider` interface for seamless integration with the DartStream authentication framework.

## Installation

Add the dependency to your `pubspec.yaml`:

```yaml
dependencies:
  ds_okta_auth_provider: ^0.0.1-pre
  ds_auth_base: ^0.0.1
```

## Configuration

Before using the Okta provider, you need to configure it with your Okta application credentials:

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_okta_auth_provider/ds_okta_auth_export.dart';

// Register the provider
DSAuthManager.registerProvider(
  'okta',
  DSOktaAuthProvider(),
  DSAuthProviderMetadata(
    type: 'okta',
    region: 'us-east-1',
    clientId: 'your-client-id',
  ),
);

// Initialize the auth manager
final authManager = DSAuthManager('okta');

// Initialize the provider with configuration
await authManager._provider.initialize({
  'oktaDomain': 'dev-12345.okta.com',
  'clientId': 'your-client-id',
  'clientSecret': 'your-client-secret',
  'redirectUri': 'http://localhost:3000/callback',
});
```

## Usage Examples

### Basic Authentication

```dart
// Create a new account
await authManager.createAccount(
  'user@example.com',
  'securePassword123',
  displayName: 'John Doe',
);

// Sign in
await authManager.signIn('user@example.com', 'securePassword123');

// Get current user
final user = await authManager.getCurrentUser();
print('Welcome, ${user.displayName}!');

// Sign out
await authManager.signOut();
```

### Token Management

```dart
// Verify token
final isValid = await authManager.verifyToken();
if (isValid) {
  print('Token is valid');
}

// Refresh token
final newToken = await authManager.refreshToken('current-refresh-token');
print('New access token: $newToken');
```

### Multi-Factor Authentication (MFA)

```dart
final provider = authManager._provider as DSOktaAuthProvider;

// Enable MFA for current user
await provider.enableMFA('sms'); // or 'email', 'totp', etc.

// Disable MFA
await provider.disableMFA();

// Check MFA status
final user = await authManager.getCurrentUser();
final mfaEnabled = user.customAttributes?['mfaEnabled'];
print('MFA enabled: $mfaEnabled');
```

### Group Management

```dart
final provider = authManager._provider as DSOktaAuthProvider;
final user = await authManager.getCurrentUser();

// Get user groups
final groups = await provider.getUserGroups(user.id);
print('User groups: $groups');

// Assign user to group
await provider.assignUserToGroup(user.id, 'Admins');

// Remove user from group
await provider.removeUserFromGroup(user.id, 'Admins');
```

### User Management

```dart
final provider = authManager._provider as DSOktaAuthProvider;

// Get user by ID
final user = await provider.getUser('okta_user_example_com');

// Reset password
await provider.resetPassword('user@example.com');
```

### Audit Logs

```dart
final provider = authManager._provider as DSOktaAuthProvider;
final user = await authManager.getCurrentUser();

// Get audit logs for user
final logs = await provider.getAuditLogs(user.id);
for (final log in logs) {
  print('Event: ${log['event']}, Result: ${log['result']}');
  print('Timestamp: ${log['timestamp']}');
}
```

### Error Handling

```dart
try {
  await authManager.signIn('user@example.com', 'wrongPassword');
} on DSAuthError catch (e) {
  print('Authentication error: ${e.message}');
  if (e.code != null) {
    print('Error code: ${e.code}');
  }
}
```

## Features

- ✅ User authentication (sign in/sign out)
- ✅ Account creation
- ✅ Token management (verification and refresh)
- ✅ Multi-factor authentication (MFA)
- ✅ Group management
- ✅ User retrieval by ID
- ✅ Password reset
- ✅ Audit logs
- ✅ Custom user attributes
- ✅ Lifecycle hooks (onLoginSuccess, onLogout)

## Provider-Specific Methods

In addition to the standard `DSAuthProvider` interface methods, the Okta provider includes:

| Method | Description |
|--------|-------------|
| `enableMFA(factorType)` | Enable multi-factor authentication |
| `disableMFA()` | Disable multi-factor authentication |
| `getUserGroups(userId)` | Get list of groups for a user |
| `assignUserToGroup(userId, groupId)` | Assign user to a group |
| `removeUserFromGroup(userId, groupId)` | Remove user from a group |
| `resetPassword(email)` | Initiate password reset |
| `getAuditLogs(userId)` | Get audit logs for a user |

## Testing

Run tests with:

```bash
dart test
```

## Lifecycle Hooks

The provider supports lifecycle hooks for custom behavior:

```dart
class CustomOktaProvider extends DSOktaAuthProvider {
  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    await super.onLoginSuccess(user);
    // Custom logic after successful login
    print('User ${user.email} logged in successfully');
  }

  @override
  Future<void> onLogout() async {
    await super.onLogout();
    // Custom logic after logout
    print('User logged out');
  }
}
```

## Mock Implementation

Note: This is currently a mock implementation for development and testing purposes. The provider simulates Okta authentication behavior without making actual API calls. In production, this should be replaced with actual Okta SDK integration.

## License

Licensed under BSD-3. See [LICENSE](../../../LICENSE.md) for details.

## Contributing

Contributions are welcome! Please see the main DartStream repository for contribution guidelines.

## Support

For issues and questions, please visit the [GitHub repository](https://github.com/aortem/dartstream).