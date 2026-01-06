# DartStream

## DS Auth0 Dart Auth SDK

This package provides a DartStream‑compatible Auth0 authentication integration.  
It implements the core `DSAuthProvider` interface, handling Auth0’s OAuth flows, session & token management, error mapping, and event emission—so you can swap in Auth0 without touching your app’s auth core.

**Key components**  
- **`ds_auth0_auth_export.dart`** – Re‑exports the provider and all its helpers.  
- **`DSAuth0AuthProvider`** – Implements `DSAuthProvider`; your entry point for Auth0 auth.  
- **`src/ds_token_manager.dart`** – JWT storage, expiry tracking, validation.  
- **`src/ds_session_manager.dart`** – Session lifecycle, device tracking, expiry logic.  
- **`src/ds_error_mapper.dart`** – Translates Auth0 errors into `DSAuthError`.  
- **`src/ds_event_handlers.dart`** – Emits `DSAuthEvent` callbacks (signed in, token refreshed, etc.).

---

## Configuration

Construct your provider with your Auth0 application credentials:

```dart
final auth0 = DSAuth0AuthProvider(
  domain: 'your‑tenant.auth0.com',
  clientId: 'YOUR_CLIENT_ID',
  clientSecret: 'YOUR_CLIENT_SECRET',
  audience: 'https://api.yoursite.com/',  // Auth0 API Identifier
);
await auth0.initialize({ /* optional extra settings */ });
````

| Option         | Description                                        |
| -------------- | -------------------------------------------------- |
| `domain`       | Your Auth0 tenant (e.g. `acme.auth0.com`)          |
| `clientId`     | Auth0 Application Client ID                        |
| `clientSecret` | Auth0 Application Client Secret                    |
| `audience`     | Auth0 API Audience (for access tokens & user info) |

---

## Public API

### Core `DSAuthProvider` methods

```dart
await auth0.initialize({});                              // must call before others
await auth0.signIn('user@example.com', 'password123');   // password grant
await auth0.signOut();                                   // revoke & clear state
await auth0.createAccount('new@user.com','pass',{        // signup  
  displayName: 'New User',
});
DSAuthUser user     = await auth0.getCurrentUser();      // throws if none
DSAuthUser user2    = await auth0.getUser('auth0|123');  // fetch by ID
bool      valid     = await auth0.verifyToken();         // checks expiry
String    newToken  = await auth0.refreshToken(oldRef);  // refresh grant
await auth0.onLoginSuccess(user);                        // hookable callback
await auth0.onLogout();                                  // hookable callback
```

### Auth0‑specific helpers

```dart
await auth0.sendPasswordResetEmail('user@example.com');
await auth0.updateProfile(
  displayName: 'Updated Name',
  photoURL: 'https://…/avatar.png',
);
await auth0.deleteUser();  // removes user via Auth0 Management API
```

---

## Usage Example

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:auth0_dart_auth_sdk/ds_auth0_auth_export.dart';

void main() async {
  final provider = DSAuth0AuthProvider(
    domain: 'acme.auth0.com',
    clientId: 'XXXX',
    clientSecret: 'YYYY',
    audience: 'https://api.acme.com/',
  );

  // Wire into the central manager for event callbacks:
  final manager = DSAuthManager();
  manager.registerProvider(
    provider,
    onEvent: (e) => print('Auth0 event: ${e.type} → ${e.data}'),
  );

  // Init & sign in
  await manager.initialize();
  await provider.signIn('alice@acme.com','S3cret!');
  final user = await provider.getCurrentUser();
  print('Hello, ${user.displayName}!');
}
```

---

## Package Conflicts and Aliases

All classes in this package are prefixed with `DSAuth0…` to avoid naming collisions with other SDKs. No additional aliasing is required.

---

## Licensing

All Dartstream packages are licensed under BSD-3, except for the *services packages*, which uses the ELv2 license, and the *Dartstream SDK packages*, which are licensed from third party software Aortem Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).  See the [LICENSE](LICENSE.md) file for more details.


## Enhance with DartStream

We hope DartStream helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!