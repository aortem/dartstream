# DartStream Magic Authentication Provider Documentation

## Overview

This document provides onboarding, system design, and API documentation for the Magic authentication provider in DartStream. It is intended for contributors, integrators, and reviewers to understand Magic’s capabilities, architecture, and usage within the DartStream framework.

---

## 1. Onboarding

### **Setup & Configuration**

1. **Add the Magic Provider Package**  
   Ensure `ds_magic_auth_provider` is included in your DartStream backend dependencies.

2. **Configuration Example**
   ```dart
   final config = {
     'publishableKey': 'your-magic-publishable-key',
     'secretKey': 'your-magic-secret-key',
   };
   await magicProvider.initialize(config);
   ```

3. **Initialization**
   ```dart
   final magicProvider = DSMagicAuthProvider(
     publishableKey: 'your-magic-publishable-key',
     secretKey: 'your-magic-secret-key',
   );
   await magicProvider.initialize(config);
   ```

4. **Register with DSAuthManager**
   ```dart
   DSAuthManager.registerProvider('magic', magicProvider);
   ```

---

## 2. System Design

### **Architecture & Key Components**

- **Provider Class**: `DSMagicAuthProvider` implements the `DSAuthProvider` interface for DartStream.
- **Passwordless Authentication**: Uses Magic’s DID token for secure, passwordless sign-in.
- **Token Management**: Handles DID token storage, validation, and expiration using `DSTokenManager`.
- **Session Management**: Tracks user sessions with `DSSessionManager`.
- **User Management**: User info is extracted from the DID token; direct user lookup is not supported by Magic API.
- **Error Handling**: Uses `DSMagicErrorMapper` to standardize error reporting.
- **Extensibility**: Lifecycle hooks for login/logout events; ready for future Magic SDK/event support.

### **Security Considerations**

- All authentication is passwordless and based on Magic’s DID token.
- DID tokens are verified with Magic’s API for authenticity.
- No password is ever stored or transmitted.
- Sessions and tokens are managed securely in memory.

---

## 3. API Documentation

### **Core DSAuthProvider Interface Methods (Magic Implementation)**

| Method | Description |
|--------|-------------|
| `initialize(Map<String, dynamic> config)` | Initialize with Magic publishable and secret keys. |
| `createAccount(String email, String password, {String? displayName})` | Registers a user (triggers sign-in; Magic is passwordless). |
| `signIn(String email, String password)` | Authenticates a user using a Magic DID token (password param is the DID token from frontend). |
| `signOut()` | Terminates the current session and clears tokens. |
| `getCurrentUser()` | Retrieves the currently authenticated user by verifying the DID token. |
| `getUser(String userId)` | Not supported (throws UnimplementedError; store user info after sign-in if needed). |
| `verifyToken([String? token])` | Verifies a DID token with Magic’s API. |
| `refreshToken(String refreshToken)` | Not supported (throws UnimplementedError; re-authenticate instead). |
| `onLoginSuccess(DSAuthUser user)` | Lifecycle hook for login success. |
| `onLogout()` | Lifecycle hook for logout. |

### **Magic-Specific Notes**
- **Passwordless Flow**: The frontend triggers Magic link login and receives a DID token, which is sent to the backend for verification.
- **No Direct User Lookup**: Magic does not support fetching user info by ID; store user info after sign-in if needed.
- **No Token Refresh**: Magic tokens are short-lived; re-authentication is required for renewal.
- **No MFA/Groups/Audit Logs**: These features are not provided by Magic’s API.

---

## 4. Testing

### **Test Coverage**

- **Basic Provider Tests**: Initialization, configuration, passwordless sign-in, sign-out, and error handling.
- **Comprehensive Tests**: DID token validation, session management, edge cases (missing/invalid tokens, uninitialized provider).
- **Integration Tests**: End-to-end passwordless authentication workflows.

### **How to Run Tests**

```bash
# Run all Magic provider tests
cd ~/Desktop/dartstream-opensource/dartstream && dart test test/standard/extensions/auth/providers/magic/

# Run specific test suites
dart test test/standard/extensions/auth/providers/magic/ds_magic_auth_provider_test.dart
```

### **Test Categories**

- Passwordless Authentication: Magic link flow, DID token verification
- Token Management: Storage, expiration, and validation
- Session Management: Creation, removal, and validation
- Error Handling: Edge cases, failure scenarios
- Integration: End-to-end Magic authentication

---

## 5. Production Considerations

- Securely store Magic keys and secrets.
- Monitor for failed authentication attempts and unusual activity.
- Regularly update dependencies and review Magic’s API documentation for changes.
- Store user info after sign-in if you need to support user lookup or profile features.