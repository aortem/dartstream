# DartStream Magic Authentication Provider

A DartStream authentication provider implementing Magic Authentication services.

## Features

* Passwordless authentication via Magic DID tokens
* Token management
* Session handling
* Error mapping
* Event system integration
* Lifecycle management

## Installation

1. Add to your `pubspec.yaml`:

```yaml
dependencies:
  # Magic Authentication provider for DartStream
  ds_magic_auth_provider: ^0.0.3

  # Base authentication package
  ds_auth_base: ^0.0.1

  # Framework features
  ds_standard_features: ^0.0.8
```

## Usage

### Basic Setup

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_magic_auth_provider/ds_magic_auth_provider.dart';

// Initialize Magic Provider with your keys
final magicProvider = DSMagicAuthProvider(
  publishableKey: 'your-magic-publishable-key',
  secretKey: 'your-magic-secret-key',
);
await magicProvider.initialize({
  'publishableKey': 'your-magic-publishable-key',
  'secretKey': 'your-magic-secret-key',
});

// Register with DartStream Auth Manager
DSAuthManager.registerProvider('magic', magicProvider);
```

## Architecture

### Components

1. **Provider (`ds_magic_auth_provider.dart`)**

   * Implements the `DSAuthProvider` interface
   * Integrates with Magic’s DID token API
2. **Token Manager (`ds_token_manager.dart`)**

   * Handles DID token storage, validation, expiration
3. **Session Manager (`ds_session_manager.dart`)**

   * Manages user sessions in memory
4. **Error Mapper (`ds_error_mapper.dart`)**

   * Maps Magic API errors to `DSAuthError`
5. **Event Handlers (`ds_event_handlers.dart`)**

   * Hooks for login/logout events

## Implementation Status

### Completed Features

* [x] Initialization (`initialize`)
* [x] Passwordless sign-in (`signIn` using DID token)
* [x] Sign-out (`signOut`)
* [x] Current user retrieval (`getCurrentUser`)
* [x] Token verification (`verifyToken`)
* [x] Session management via `DSSessionManager`
* [x] Error mapping with `DSMagicErrorMapper`
* [x] Lifecycle hooks (`onLoginSuccess`, `onLogout`)

### Limitations & Notes

* **No `getUser` support**: Magic API doesn’t provide direct user lookup;
  store user info after sign-in if needed.
* **No `refreshToken`**: DID tokens are short-lived; re-authentication required.
* **No MFA/Groups/Audit Logs**: Not offered by Magic’s API.

## Enhanced Usage Examples

```dart
// Magic link flow: front-end obtains DID token and sends it to backend
final didToken = await magicSdk.loginWithMagicLink('user@example.com');
await magicProvider.signIn('user@example.com', didToken);

// Listen to login success event
magicProvider.onLoginSuccess((user) {
  print('User signed in: ${user.uid}');
});

// Validate token
final valid = await magicProvider.verifyToken(didToken);
print('Token valid: $valid');
```

## Testing

### Running Tests

```bash
# Run all tests for Magic provider
cd packages/standard/standard_extensions/auth/providers/magic
dart test
```

### Test Coverage

* Passwordless Authentication flows
* Token management edge cases
* Session creation/removal
* Error handling scenarios
* Lifecycle event triggers

## Production Setup

1. **Obtain Magic Keys**

   * Create a Magic account and get publishable & secret keys
2. **Secure Storage**

   * Store keys in environment variables or Secret Manager
3. **Configure Provider**

   ```bash
   export MAGIC_PUBLISHABLE_KEY="your-key"
   export MAGIC_SECRET_KEY="your-secret"
   ```

## Framework Integration

### DartStream Backend

```dart
// In your main.dart or bootstrap
configureLogging(Tier.enterprise);
await magicProvider.initialize(...);
DSAuthManager.registerProvider('magic', magicProvider);
```

### Flutter Integration

```dart
import 'package:ds_flutter_mobile/ds_flutter_mobile.dart';
await DSFlutterMobileCore.initialize(
  defaultAuthProvider: 'magic',
  enableLogging: true,
);
```

## Security Features

* No passwords stored or transmitted
* DID token verification via Magic API
* In-memory session handling
* Standardized error reporting

## Troubleshooting

* **Uninitialized provider**: Ensure `initialize` is called before use.
* **Invalid DID token**: Verify token with `verifyToken` method.
* **Missing hooks**: Check that event handlers are registered.

## Performance Considerations

* Lightweight in-memory session manager
* No heavy Crypto operations on every request
* Single HTTP call to Magic API for token verification

## Status: Production Ready 🚀

The Magic authentication provider is **complete and production-ready** with passwordless login, robust session management, and comprehensive testing.
