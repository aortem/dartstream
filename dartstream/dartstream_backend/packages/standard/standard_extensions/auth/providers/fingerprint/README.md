# DSFingerprintAuthProvider

A production-ready authentication provider for [DartStream](https://dartstream.dev) using the [Fingerprint Dart Auth SDK](https://pub.dev/packages/fingerprint_dart_auth_sdk). This provider supports passwordless authentication using secure device fingerprinting and visitor payloads.

---

## Features

- Authenticate users with FingerprintJS payloads
- Stateless verification via `visitorId`
- Session and token tracking via internal managers
- Pluggable with the `DSAuthProvider` interface

---

## Installation

```bash
dart pub add fingerprint_dart_auth_sdk
```

---

## API Usage

`initialize(Map config)`
Initializes session and token managers.
```dart
await provider.initialize({});
```

`signIn(String email, String payload)`
Authenticates a user via fingerprint payload (JSON string).
```dart
await provider.signIn('user@example.com', fingerprintPayloadJson);
```

`getCurrentUser()`
Returns the currently signed-in user, if any.
```dart
final user = await provider.getCurrentUser();
```

`verifyToken([String? payload])`
Verifies a payload's authenticity and structure.
```dart
final isValid = await provider.verifyToken(jsonPayload);
```

---

## User Onboarding

- Step 1: Generate FingerprintJS Payload
Use the FingerprintJS Pro client in your frontend to collect the fingerprint.
```
const fp = await FingerprintJS.load();
const result = await fp.get();
sendToBackend(result);
```

- Step 2: Authenticate from Backend
```
await provider.signIn(userEmail, jsonEncode(fingerprintPayload));
```

- Step 3: Token and Session Managed Internally
The provider stores the visitor ID and starts a session automatically.

## System Design Overview

### Architecture

```
[Frontend]
   |
   |--- FingerprintJS Pro (collects device fingerprint)
   |
[Backend (Dart)]
   |
   |--- DSFingerprintAuthProvider
          |
          |- AortemFingerprintAuth.verify()
          |- DSTokenManager (stores payload as token)
          |- DSSessionManager (tracks session)
```

### Core Components

- `AortemFingerprintAuth`: Verifies fingerprint payloads

- `DSTokenManager`: Manages tokens (payloads)

- `DSSessionManager`: Tracks active sessions

- `DSAuthUser`: Standard user representation

### Design Notes

- Fingerprint payload = token (no JWTs)

- Stateless and secure (verification-only)

- No token refresh supported

- Sessions expire based on configured duration