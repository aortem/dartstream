# DartStream Transmit Authentication Provider

## Overview

The Transmit provider adds modular authentication capabilities to DartStream, following the same structure and technical approach as the Auth0 and Magic providers.

## Features

- Passwordless or conventional Transmit authentication (based on Transmit API capabilities)
- Token management: secure storage, validation, renewal (if supported)
- Session management: active session tracking and validation
- Lifecycle event hooks: handle login/logout and other authentication events

## Entry-point registration (recommended)

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:ds_transmit_auth_provider/ds_transmit_auth_export.dart';

Future<void> main() async {
  registerTransmitProvider({
    'name': 'transmit',
    // 'region': 'global',
    // 'clientId': 'your-client-id',
  });

  final auth = DSAuthManager('transmit');
  await auth.initialize({
    'clientId': 'your-client-id',
    'clientSecret': 'your-client-secret',
    // '__dev__': true,
  });
}
```

## Directory Structure

```
transmit/
  lib/
    src/
      ds_error_mapper.dart
      ds_event_handlers.dart
      ds_session_manager.dart
      ds_token_manager.dart
    ds_transmit_auth_entry.dart
    ds_transmit_auth_export.dart
    ds_transmit_auth_provider.dart
  CHANGELOG.md
  LICENSE
  manifest.yaml
  pubspec.yaml
  README.md
```

## Key Dart Files

- **lib/src/ds_error_mapper.dart**: Maps Transmit-specific errors to standardized DartStream error codes.
- **lib/src/ds_event_handlers.dart**: Handles provider-related authentication events.
- **lib/src/ds_session_manager.dart**: Manages the user session lifecycle.
- **lib/src/ds_token_manager.dart**: Handles access token storage, retrieval, and renewal logic.
- **lib/ds_transmit_auth_export.dart**: Barrel export file for public APIs.
- **lib/ds_transmit_auth_provider.dart**: Transmit-specific provider class with main authentication logic.

## DSTransmitAuthProvider

A Dart provider implementing the `DSAuthProvider` interface, using the Transmit Authentication SDK (`transmit_dart_auth_sdk`) for robust, modular authentication workflows in Dart/Flutter backends.

### Features

- Authentication with username/password using Transmit API.
- Access & refresh token management via dedicated managers.
- Session tracking logic and helpers.
- Token verification endpoint support.
- Custom error mapping for predictable handling.
- Lifecycle event hooks for login/logout.

### API Docs

#### Initialization

```dart
Future<void> initialize(Map<String, dynamic> config)
```

- Initialize with `{ clientId, clientSecret, region? }`.
- Example:

```dart
await provider.initialize({
  'clientId': 'your_client_id',
  'clientSecret': 'your_client_secret',
  'region': 'global',
});
```

#### Sign In

```dart
Future<void> signIn(String username, String password)
```

- Authenticates a user.
- Stores tokens, session, and user info on success.

#### Sign Out

```dart
Future<void> signOut()
```

- Logs out, clears session/token state.

#### Refresh Token

```dart
Future<String> refreshToken(String refreshToken)
```

- Exchanges refresh token for a new access token.

#### Verify Token

```dart
Future<bool> verifyToken([String? token])
```

- Checks validity of the (given/current) access token.

#### Getter, Hooks, and Unimplemented

- `Future<DSAuthUser> getCurrentUser()` - returns current user.
- `Future<void> createAccount(...)` and `Future<DSAuthUser> getUser(...)` - not supported (throw `UnimplementedError`).
- `Future<void> onLoginSuccess(DSAuthUser user)` and `Future<void> onLogout()` - override for custom lifecycle behavior.

## User Docs / Onboarding

 1. Add Dependency: Add `ds_transmit_auth_provider` to your `pubspec.yaml` (it uses `transmit_dart_auth_sdk` internally).
 2. Provider Setup: Create and initialize `DSTransmitAuthProvider` with the necessary configuration.
 3. Sign-In Flow: Use `signIn(username, password)` to authenticate; access user and token state from the provider.
 4. Session/Token Management: Use `refreshToken` and `verifyToken` helpers to maintain sessions.
 5. Sign Out: Use `signOut()` to clear session state.
 6. Error Handling: Error messages are mapped to standard codes for easier handling (see Error Mapping in System Design).

## System Design / Architecture

- Separation of Concerns:
- Errors (`DSTransmitErrorMapper`), tokens (`DSTransmitTokenManager`), sessions (`DSTransmitSessionManager`), and events (`DSTransmitEventHandlers`) are separate classes for modularity and clarity.
- Transmit SDK Integration:
- Uses `TransmitAuthConfig` and `ApiClient` for secure HTTP REST interaction and token lifecycle.
- Stateless Client Logic:
- All network methods hit the Transmit API directly, using client credentials for auth, and maintain stateless operation via token/session managers.
- Extensible Events:
- `onLoginSuccess` and `onLogout` lifecycle hooks can be customized.
- Error Mapping:
- Transmit-specific error codes (e.g., `INVALID_TOKEN`, `USER_NOT_FOUND`) are mapped to your auth system's error taxonomy for consistency.
- DSAuthProvider Compatibility:
- This provider is drop-in compatible with the DartStream auth ecosystem and can be used interchangeably with other providers.

## Core API Methods

| Method               | Description                                   |
|----------------------|-----------------------------------------------|
| `initialize(config)` | Provider setup and configuration              |
| `signIn(username, password)` | Sign in user using Transmit credentials |
| `signOut()`          | End the current user session                  |
| `getCurrentUser()`   | Retrieve the current authenticated user       |
| `verifyToken(token)` | Validate a given token with Transmit's API    |

## Project Files (Descriptions)

| File                              | Purpose                                    |
|------------------------------------|--------------------------------------------|
| `lib/src/ds_error_mapper.dart`     | Error code mapping logic                   |
| `lib/src/ds_event_handlers.dart`   | Authentication event/lifecycle hooks       |
| `lib/src/ds_session_manager.dart`  | Session state manager                      |
| `lib/src/ds_token_manager.dart`    | Token handling/utilities                   |
| `lib/ds_transmit_auth_export.dart` | Public package exports                     |
| `lib/ds_transmit_auth_provider.dart`| Provider-specific logic                   |
| `CHANGELOG.md`                    | Change tracking for the package            |
| `LICENSE`                         | Usage licensing information                |
| `manifest.yaml`                   | Package meta-information                   |
| `pubspec.yaml`                    | Dart dependency and configuration details  |
| `README.md`                       | Onboarding, architecture, and API guides   |

## Notes

- Follow this structure and modular approach for maintainability and extensibility.
- Ensure all secrets and API keys are securely managed.
- Update dependencies and documentation as Transmit or DartStream evolves.


