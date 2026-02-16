# DartStream Ping Identity Mock Provider

A complete mock implementation of Ping Identity authentication for the DartStream framework. This package provides a fully functional authentication provider for testing and development without requiring actual Ping Identity credentials.

## Features

✅ **Complete DSAuthProvider Implementation** - Full compliance with DartStream authentication interface  
✅ **Token Management** - Simulated JWT token generation, validation, and refresh  
✅ **Session Management** - User session tracking and lifecycle management  
✅ **Error Mapping** - Ping-specific error codes mapped to DSAuthError  
✅ **Event Handling** - Comprehensive event logging and lifecycle hooks  
✅ **Mock User Database** - Pre-configured test users for immediate use  
✅ **Testing Utilities** - Built-in helpers for resetting state and adding mock users

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  ds_auth_base:
    path: ../../base
  ds_ping_auth:
    path: ../../providers/ping
```

## Entry-point registration (recommended)

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_ping_auth/ds_ping_auth_export.dart';

Future<void> main() async {
  registerPingProvider({
    'name': 'ping',
    // 'region': 'us-east-1',
    // 'clientId': 'mock-client-id',
  });

  final auth = DSAuthManager('ping');
  await auth.initialize({
    'clientId': 'mock-client-id',
    'issuer': 'https://auth.pingone.com/mock-env-id',
    'redirectUri': 'https://yourapp.com/callback',
  });
}
```

## Quick Start

### 1. Register the Provider

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_ping_auth/ds_ping_auth_export.dart';

void main() async {
  // Register Ping provider with metadata
  DSAuthManager.registerProvider(
    'ping',
    DSPingAuthProvider(),
    DSAuthProviderMetadata(
      type: 'ping',
      region: 'us-east-1',
      clientId: 'mock-client-id',
    ),
  );
}
```

### 2. Initialize and Configure

```dart
// Create auth manager instance
final authManager = DSAuthManager('ping');

// Initialize with configuration
await authManager._provider.initialize({
  'clientId': 'mock-client-id',
  'issuer': 'https://auth.pingone.com/mock-env-id',
  'redirectUri': 'https://yourapp.com/callback',
});
```

### 3. Use Authentication

```dart
try {
  // Sign in with pre-configured test user
  await authManager.signIn('test@example.com', 'password123');
  
  // Get current user
  final user = await authManager.getCurrentUser();
  print('Logged in as: ${user.displayName}');
  
  // Verify token
  final isValid = await authManager.verifyToken();
  print('Token valid: $isValid');
  
  // Sign out
  await authManager.signOut();
} catch (e) {
  print('Auth error: $e');
}
```

## Pre-configured Test Users

The mock provider comes with two test users:

| Email | Password | Display Name | Role |
|-------|----------|--------------|------|
| test@example.com | password123 | Test User | Developer |
| admin@example.com | admin123 | Admin User | Administrator |

## Advanced Usage

### Creating New Accounts

```dart
await authManager.createAccount(
  'newuser@example.com',
  'securePass123',
  displayName: 'New User',
);
```

### Token Refresh

```dart
// Get refresh token (would typically be stored securely)
final tokenManager = DSPingTokenManager(config);
final refreshToken = tokenManager.getRefreshToken(currentToken);

// Refresh access token
final newToken = await authManager.refreshToken(refreshToken!);
```

### Event Handling

```dart
final provider = DSPingAuthProvider();
await provider.initialize(config);

// Access event handlers
final eventHandlers = provider._eventHandlers;
eventHandlers.enableLogging = true;

// Set custom callbacks
eventHandlers.onSignInCallback = (user) async {
  print('User signed in: ${user.email}');
};

eventHandlers.onErrorCallback = (error) async {
  print('Error occurred: ${error.message}');
};

// View event history
final signInEvents = eventHandlers.getEventHistory(eventType: 'SIGN_IN');
print('Sign in count: ${eventHandlers.getEventCount('SIGN_IN')}');
```

### Error Handling

```dart
try {
  await authManager.signIn('invalid@example.com', 'wrongpass');
} on DSAuthError catch (e) {
  final errorMapper = DSPingErrorMapper();
  
  // Get user-friendly message
  print(errorMapper.getUserFriendlyMessage(e));
  
  // Check if retryable
  if (errorMapper.isRetryableError(e)) {
    print('This error can be retried');
  }
  
  print('Error code: ${e.code}');
}
```

## Testing Utilities

### Reset Mock Data

```dart
// Reset to default test users
DSPingAuthProvider.resetMockData();
```

### Add Custom Mock Users

```dart
DSPingAuthProvider.addMockUser(
  _MockUser(
    id: 'custom_001',
    email: 'custom@example.com',
    password: 'custompass',
    displayName: 'Custom User',
    customAttributes: {'role': 'tester'},
  ),
);
```

### Enable Debug Logging

```dart
// Enable manager-level logging
DSAuthManager.enableDebugging = true;

// Enable event logging
eventHandlers.enableLogging = true;
```

### Clear Session History

```dart
final sessionManager = DSPingSessionManager(config);
sessionManager.clearHistory();
```

## Architecture

The mock provider is composed of four main modules:

### 1. **DSPingAuthProvider**
Main provider class implementing the `DSAuthProvider` interface. Coordinates all authentication operations.

### 2. **DSPingTokenManager**
Handles token generation, validation, and refresh operations. Simulates JWT-style tokens with expiration.

### 3. **DSPingSessionManager**
Manages user sessions, tracking creation time, last access, and session lifecycle.

### 4. **DSPingErrorMapper**
Maps Ping Identity-specific errors to standardized `DSAuthError` objects with appropriate codes and messages.

### 5. **DSPingEventHandlers**
Tracks authentication events and provides lifecycle hooks for monitoring and debugging.

## Configuration Options

The provider accepts the following configuration parameters:

```dart
{
  'clientId': 'your-client-id',           // Required
  'issuer': 'https://auth.pingone.com/',  // Required
  'redirectUri': 'https://app.com/callback', // Required
  'scopes': ['openid', 'profile', 'email'], // Optional
  'tokenExpiration': 3600,                 // Optional (seconds)
  'refreshTokenExpiration': 2592000,       // Optional (seconds)
}
```

## Error Codes

| Code | Error Type | Description |
|------|------------|-------------|
| 400 | WEAK_PASSWORD | Password doesn't meet requirements |
| 401 | INVALID_CREDENTIALS | Invalid username or password |
| 401 | INVALID_TOKEN | Token is invalid or malformed |
| 401 | TOKEN_EXPIRED | Token has expired |
| 401 | NO_SESSION | No active session found |
| 404 | USER_NOT_FOUND | User doesn't exist |
| 409 | USER_EXISTS | User already exists |
| 500 | UNKNOWN | Unknown error occurred |
| 503 | NETWORK_ERROR | Network connection error |

## Lifecycle Hooks

Override these methods in your provider implementation:

```dart
class CustomPingProvider extends DSPingAuthProvider {
  @override
  Future<void> onLoginSuccess(DSAuthUser user) async {
    print('Custom login logic for: ${user.email}');
    // Add analytics, notifications, etc.
  }
  
  @override
  Future<void> onLogout() async {
    print('Custom logout logic');
    // Clear caches, close connections, etc.
  }
}
```

## Differences from Real Ping Identity

This mock implementation simulates Ping Identity behavior for development and testing. Key differences:

- No actual network calls to Ping servers
- Simplified token structure (not real JWTs)
- In-memory storage only (no persistence)
- Instant operations (no real latency)
- Pre-configured test users

For production, replace this with the actual Ping Identity SDK.

## License

This package is licensed under BSD-3, matching the DartStream framework license.

## Contributing

Contributions are welcome! Please see the main DartStream repository for contribution guidelines.

## Support

For issues and questions:
- GitHub: [github.com/aortem/ping-identity-dart-auth-sdk](https://github.com/aortem/ping-identity-dart-auth-sdk)
- Documentation: [dartstream.dev](https://dartstream.dev)

## Related Packages

- `ds_auth_base` - Base authentication interfaces
- `ds_firebase_auth` - Firebase authentication provider
- `ds_auth0_auth` - Auth0 authentication provider
- `ds_okta_auth` - Okta authentication provider
