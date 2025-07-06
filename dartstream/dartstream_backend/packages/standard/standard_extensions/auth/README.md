# DartStream

## DS Standard Packages

DS Standard packages allow you to utilize core dart features maintained by the Dart team.  The depdendencies remain largely unmodified.  Dartstream extends the built-in classes and methods, therefore allowing developers the greatest composition flexibility when building their applications.

---

## Supported Authentication SDKs

DartStream provides first-class integration with the following 10 authentication SDKs. Install them via Pub and find source, issues, and examples on GitHub:

| Provider        | Package Name                   | Pub Dev                                                          | GitHub                                                            |
| --------------- | ------------------------------ | ---------------------------------------------------------------- | ----------------------------------------------------------------- |
| **Auth0**       | `auth0_dart-auth-sdk`          | [pub.dev](https://pub.dev/packages/auth0_dart_auth_sdk)          | [github](https://github.com/aortem/auth0-dart-auth-sdk)           |
| **Cognito**     | `cognito_dart-auth-sdk`        | [pub.dev](https://pub.dev/packages/cognito_dart_auth_sdk)        | [github](https://github.com/aortem/cognito-dart-auth-sdk)         |
| **EntraId**     | `entra-id-dart-auth-sdk`       | [pub.dev](https://pub.dev/packages/entra_id_dart_auth_sdk)       | [github](https://github.com/aortem/entra-id-dart-auth-sdk)        |
| **Fingerprint** | `fingerprint_dart-auth-sdk`    | [pub.dev](https://pub.dev/packages/fingerprint_dart_auth_sdk)    | [github](https://github.com/aortem/fingerprint-dart-auth-sdk)     |
| **Firebase**    | `firebase_dart_admin_auth_sdk` | [pub.dev](https://pub.dev/packages/firebase_dart_admin_auth_sdk) | [github](https://github.com/aortem/firebase-dart-admin-auth-sdk)  |
| **Magic**       | `magic_dart-auth-sdk`          | [pub.dev](https://pub.dev/packages/magic_dart_auth_sdk)          | [github](https://github.com/aortem/magic-dart-auth-sdk)           |
| **Okta**        | `okta_dart-auth-sdk`           | [pub.dev](https://pub.dev/packages/okta_identity_dart_auth_sdk)  | [github](https://github.com/aortem/okta-identity-dart-auth-sdk)   |
| **Ping**        | `ping_dart-auth-sdk`           | [pub.dev](https://pub.dev/packages/ping_identity_dart_auth_sdk)  | [github](https://github.com/aortem/ping-identity-dart-auth-sdk)   |
| **Stytch**      | `stytch_dart-auth-sdk`         | [pub.dev](https://pub.dev/packages/stytch_dart_auth_sdk)         | [github](https://github.com/aortem/stytch-dart-auth-sdk)          |
| **Transmit**    | `transmit_dart-auth-sdk`       | [pub.dev](https://pub.dev/packages/transmit_dart_auth_sdk)       | [github](https://github.com/aortem/transmit-dart-auth-sdk)        |

---

## Package Conflicts and Aliases

In some cases, core dart package have naming conflicts (ie. same method, classname).  For some packages, we build wrappers and use the DS prefix to avoid those conflicts.  

In other cases, where may avoid using a package altogether.  We will keep the documentation up to date as often as possible.

## Licensing

All Dartstream packages are licensed under BSD-3, except for the *services packages*, which uses the ELv2 license, and the *Dartstream SDK packages*, which are licensed from third party software Aortem Inc. In short, this means that you can, without limitation, use any of the client packages in your app as long as you do not offer the SDK's or services as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).  See the [LICENSE](LICENSE.md) file for more details.


## Enhance with DartStream

We hope DartStream helps you to efficiently build and scale your server-side applications. Join our growing community and start contributing to the ecosystem today!

---

## Quick Start Guide

### Prerequisites

Add the required dependencies to your `pubspec.yaml`:

```yaml
dependencies:
  # Base authentication package
  ds_auth_base:
    path: path/to/auth/base
  
  # Choose your authentication provider SDK
  firebase_dart_admin_auth_sdk: ^0.0.2  # For Firebase
  # auth0_dart_auth_sdk: ^0.0.1          # For Auth0 (when available)
  
  # Framework features
  ds_standard_features: ^0.0.4
```

### Basic Setup

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';

// Register your chosen provider
DSAuthManager.registerProvider('firebase', firebaseProvider);
// or
DSAuthManager.registerProvider('auth0', auth0Provider);

// Create auth manager instance
final authManager = DSAuthManager('firebase'); // or 'auth0'
```

---

## Firebase Authentication

Firebase Authentication provides a comprehensive authentication solution with built-in security and scalability.

### Firebase Setup

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';
import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';

// Initialize Firebase App
await FirebaseApp.initializeAppWithEnvironmentVariables(
  apiKey: 'your-api-key',
  projectId: 'your-project-id',
  authdomain: 'your-project.firebaseapp.com',
  messagingSenderId: 'your-messaging-sender-id',
  bucketName: 'your-storage-bucket',
  appId: 'your-app-id',
);

// Create Firebase Auth Provider
final firebaseProvider = DSFirebaseAuthProvider(
  projectId: 'your-project-id',
  privateKeyPath: 'path/to/service-account.json',
  apiKey: 'your-api-key',
);

// Initialize the provider
await firebaseProvider.initialize({
  'projectId': 'your-project-id',
  'apiKey': 'your-api-key',
});

// Register with DartStream
DSAuthManager.registerProvider('firebase', firebaseProvider);
final authManager = DSAuthManager('firebase');
```

### Firebase Usage Examples

#### Basic Authentication Flow

```dart
// Create a new user account
await authManager.createAccount(
  'user@example.com',
  'securePassword123',
  displayName: 'John Doe',
);

// Sign in existing user
await authManager.signIn('user@example.com', 'securePassword123');

// Get current user
final currentUser = await authManager.getCurrentUser();
print('Signed in as: ${currentUser.displayName} (${currentUser.email})');

// Verify token
final isValid = await authManager.verifyToken();
print('Token is valid: $isValid');

// Sign out
await authManager.signOut();
```

#### Firebase-Specific Features

```dart
// Send password reset email
await firebaseProvider.sendPasswordResetEmail('user@example.com');

// Send email verification
await firebaseProvider.sendEmailVerification();

// Check email verification status
final isVerified = await firebaseProvider.isEmailVerified();

// Update user password
await firebaseProvider.updatePassword('newSecurePassword456');

// Update user email
await firebaseProvider.updateEmail('newemail@example.com');

// Update user profile
await firebaseProvider.updateProfile(
  displayName: 'Jane Doe',
  photoURL: 'https://example.com/photo.jpg',
);

// Delete user account
await firebaseProvider.deleteUser();
```

### Firebase Production Setup

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create new project
   - Enable Authentication
   - Enable Email/Password sign-in method

2. **Get Configuration**
   - Download service account key
   - Get project configuration values
   - Update your initialization code

3. **Environment Setup**
   ```bash
   export FIREBASE_PROJECT_ID="your-project-id"
   export FIREBASE_API_KEY="your-api-key"
   export FIREBASE_SERVICE_ACCOUNT_PATH="path/to/service-account.json"
   ```

---

## Auth0 Authentication

Auth0 provides enterprise-grade authentication with advanced features for B2B applications, compliance, and custom authentication flows.

### Auth0 Setup

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';

// Create Auth0 Auth Provider
final auth0Provider = DSAuth0AuthProvider(
  domain: 'your-tenant.auth0.com',
  clientId: 'your-client-id',
  clientSecret: 'your-client-secret',
  audience: 'https://your-api.com',
);

// Initialize the provider
await auth0Provider.initialize({
  'domain': 'your-tenant.auth0.com',
  'clientId': 'your-client-id',
  'clientSecret': 'your-client-secret',
  'audience': 'https://your-api.com',
});

// Register with DartStream
DSAuthManager.registerProvider('auth0', auth0Provider);
final authManager = DSAuthManager('auth0');
```

### Auth0 Usage Examples

#### Basic Authentication Flow

```dart
// Create a new user account
await authManager.createAccount(
  'user@company.com',
  'SecurePassword123!',
  displayName: 'Jane Smith',
);

// Sign in existing user
await authManager.signIn('user@company.com', 'SecurePassword123!');

// Get current user with Auth0 attributes
final currentUser = await authManager.getCurrentUser();
print('Signed in as: ${currentUser.displayName}');
print('Auth0 ID: ${currentUser.customAttributes?['auth0_id']}');
print('Email verified: ${currentUser.customAttributes?['email_verified']}');

// Verify JWT token
final isValid = await authManager.verifyToken();
print('JWT token is valid: $isValid');

// Refresh token
final newToken = await authManager.refreshToken('refresh_token_here');
print('New token: $newToken');

// Sign out
await authManager.signOut();
```

#### Auth0-Specific Features

```dart
// Send password reset email
await auth0Provider.sendPasswordResetEmail('user@company.com');

// Update user password
await auth0Provider.updatePassword('NewSecurePassword456!');

// Update user email
await auth0Provider.updateEmail('newemail@company.com');

// Update user profile with custom attributes
await auth0Provider.updateProfile(
  displayName: 'Jane Doe-Smith',
  photoURL: 'https://company.com/avatars/jane.jpg',
);

// Delete user account
await auth0Provider.deleteUser();

// Get user by Auth0 ID
final user = await authManager.getUser('auth0|507f1f77bcf86cd799439011');
```

#### JWT Token Management

```dart
// Verify specific JWT token
final isValidToken = await auth0Provider.verifyToken('eyJ0eXAiOiJKV1QiLCJhbGci...');

// Check token expiration
final user = await authManager.getCurrentUser();
final tokenExpiry = user.customAttributes?['token_expiry'];
print('Token expires at: $tokenExpiry');

// Handle token refresh automatically
await auth0Provider.refreshToken('refresh_token_here');
```

### Auth0 Production Setup

1. **Create Auth0 Account**
   - Go to [Auth0 Dashboard](https://manage.auth0.com/)
   - Create new tenant
   - Create new application (Regular Web Application)

2. **Configure Application**
   - Set application URLs (callback, logout, etc.)
   - Configure authentication settings
   - Enable desired connection types

3. **Get Credentials**
   - Copy Domain, Client ID, and Client Secret
   - Set up API audience if using APIs
   - Configure environment variables

4. **Environment Setup**
   ```bash
   export AUTH0_DOMAIN="your-tenant.auth0.com"
   export AUTH0_CLIENT_ID="your-client-id"
   export AUTH0_CLIENT_SECRET="your-client-secret"
   export AUTH0_AUDIENCE="https://your-api.com"
   ```

---

## Choosing the Right Provider

### Firebase vs Auth0 Comparison

| Feature | Firebase | Auth0 | Best For |
|---------|----------|-------|----------|
| **Setup Complexity** | Simple | Moderate | Firebase: Quick prototypes<br>Auth0: Enterprise apps |
| **Pricing** | Pay-as-you-grow | Tiered pricing | Firebase: Small to medium apps<br>Auth0: Predictable enterprise costs |
| **Customization** | Limited | Extensive | Firebase: Standard flows<br>Auth0: Custom authentication |
| **Compliance** | Basic | Advanced (SOC2, HIPAA, etc.) | Firebase: General use<br>Auth0: Regulated industries |
| **Social Providers** | Google ecosystem focus | 30+ providers | Firebase: Google integration<br>Auth0: Multi-provider |
| **Enterprise Features** | Limited | Comprehensive (SSO, SAML, etc.) | Firebase: Consumer apps<br>Auth0: B2B/Enterprise |
| **Multi-tenant Support** | Manual implementation | Built-in | Firebase: Single tenant<br>Auth0: Multi-tenant SaaS |
| **API Management** | Separate Firebase products | Integrated | Firebase: Simple APIs<br>Auth0: Complex API ecosystems |

### When to Use Firebase

**Choose Firebase when you need:**
- Quick setup and prototyping
- Integration with Google services
- Cost-effective scaling for consumer apps
- Simple email/password authentication
- Real-time database integration
- Mobile-first applications

### When to Use Auth0

**Choose Auth0 when you need:**
- Enterprise-grade security and compliance
- Complex authentication flows
- B2B/SaaS applications
- Multi-tenant architecture
- Extensive customization options
- Advanced user management
- Integration with existing enterprise systems
- Regulatory compliance (HIPAA, SOC2, GDPR)

---

## Framework Integration

### Flutter Mobile Integration

```dart
import 'package:ds_flutter_mobile/ds_flutter_mobile.dart';

// Initialize with Firebase
await DSFlutterMobileCore.initialize(
  defaultAuthProvider: 'firebase',
  enableLogging: true,
);

// Or initialize with Auth0
await DSFlutterMobileCore.initialize(
  defaultAuthProvider: 'auth0',
  enableLogging: true,
);
```

### Flutter Web Integration

```dart
import 'package:ds_flutter_web/ds_flutter_web.dart';

// Pre-configured auth providers are available
// Access through the web framework's auth system
final authService = DSFlutterWebCore.auth;
await authService.signIn('user@example.com', 'password');
```

### Dart Backend Integration

```dart
import 'package:ds_backend_core/ds_backend_core.dart';

// Register providers at application startup
await DSBackendCore.initialize(
  authProviders: {
    'firebase': firebaseProvider,
    'auth0': auth0Provider,
  },
  defaultAuthProvider: 'firebase',
);
```

---

## Migration Between Providers

### Firebase to Auth0 Migration

```dart
// 1. Set up Auth0 provider alongside Firebase
DSAuthManager.registerProvider('firebase', firebaseProvider);
DSAuthManager.registerProvider('auth0', auth0Provider);

// 2. Migrate users gradually
Future<void> migrateUser(String email, String password) async {
  try {
    // Get user from Firebase
    final firebaseAuth = DSAuthManager('firebase');
    await firebaseAuth.signIn(email, password);
    final firebaseUser = await firebaseAuth.getCurrentUser();
    
    // Create user in Auth0
    final auth0Auth = DSAuthManager('auth0');
    await auth0Auth.createAccount(
      email,
      password, // Use temporary password, force reset
      displayName: firebaseUser.displayName,
    );
    
    // Transfer custom attributes
    // ... migration logic ...
    
    print('User $email migrated successfully');
  } catch (e) {
    print('Migration failed for $email: $e');
  }
}

// 3. Update app configuration to use Auth0
// 4. Deprecate Firebase provider
```

### Auth0 to Firebase Migration

```dart
// Similar process in reverse
Future<void> migrateFromAuth0ToFirebase(String userId) async {
  // Get Auth0 user data
  final auth0Auth = DSAuthManager('auth0');
  final auth0User = await auth0Auth.getUser(userId);
  
  // Create Firebase user
  final firebaseAuth = DSAuthManager('firebase');
  await firebaseAuth.createAccount(
    auth0User.email,
    'temporary-password', // Force password reset
    displayName: auth0User.displayName,
  );
  
  // Migrate custom data
  // ... migration logic ...
}
```

---

## Troubleshooting

### Common Issues

#### Firebase Issues

1. **Provider not initialized**
   ```dart
   // Wrong
   final provider = DSFirebaseAuthProvider(/* config */);
   await provider.signIn(email, password); // Will fail
   
   // Correct
   final provider = DSFirebaseAuthProvider(/* config */);
   await provider.initialize(config);
   await provider.signIn(email, password);
   ```

2. **Firebase App not initialized**
   ```dart
   // Wrong - using provider before Firebase app init
   final provider = DSFirebaseAuthProvider(/* config */);
   
   // Correct - initialize Firebase app first
   await FirebaseApp.initializeAppWithEnvironmentVariables(/* config */);
   final provider = DSFirebaseAuthProvider(/* config */);
   ```

3. **Service account key issues**
   ```bash
   # Ensure proper file permissions
   chmod 600 /path/to/service-account.json
   
   # Verify file format (should be valid JSON)
   cat /path/to/service-account.json | jq .
   ```

#### Auth0 Issues

1. **Domain configuration**
   ```dart
   // Wrong - missing https or incorrect format
   domain: 'my-tenant.auth0.com'
   
   // Correct - just the domain name
   domain: 'my-tenant.auth0.com'
   ```

2. **Client credentials**
   ```dart
   // Wrong - using public client credentials
   clientSecret: null // This won't work for backend
   
   // Correct - use Regular Web Application credentials
   clientSecret: 'your-client-secret'
   ```

3. **Audience configuration**
   ```dart
   // Wrong - missing or incorrect audience
   audience: ''
   
   // Correct - match your API audience
   audience: 'https://your-api.com'
   ```

#### General Issues

1. **Import errors**
   ```dart
   // Wrong imports
   import 'package:firebase_auth/firebase_auth.dart'; // Client SDK
   
   // Correct imports for backend
   import 'package:ds_auth_base/ds_auth_base_export.dart';
   import 'package:firebase_dart_admin_auth_sdk/firebase_dart_admin_auth_sdk.dart';
   ```

2. **Provider registration**
   ```dart
   // Wrong - registering after trying to use
   final manager = DSAuthManager('firebase'); // Will fail
   DSAuthManager.registerProvider('firebase', provider);
   
   // Correct - register before using
   DSAuthManager.registerProvider('firebase', provider);
   final manager = DSAuthManager('firebase');
   ```

### Debug Mode

Enable debug logging to troubleshoot issues:

```dart
// Enable detailed logging
DSAuthManager.enableDebugging = true;

// This will show:
// - Provider registration events
// - Authentication attempts
// - Token validation steps
// - Error details
```

### Testing Authentication Providers

```dart
// Test provider connectivity
Future<void> testProvider(String providerName) async {
  try {
    final authManager = DSAuthManager(providerName);
    
    // Test basic operations
    print('Testing $providerName provider...');
    
    // This should work without real credentials in test mode
    final isValid = await authManager.verifyToken('test-token');
    print('Token verification test: ${isValid ? 'PASSED' : 'FAILED'}');
    
    print('$providerName provider test completed');
  } catch (e) {
    print('$providerName provider test failed: $e');
  }
}

// Run tests
await testProvider('firebase');
await testProvider('auth0');
```

---
