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

## AWS Cognito Authentication

AWS Cognito provides secure, scalable authentication and user management for web and mobile applications. DartStream's Cognito provider offers seamless integration with AWS Cognito User Pools.

### Cognito Setup

```dart
import 'package:ds_auth_base/ds_auth_base_export.dart';

// Create Cognito Auth Provider
final cognitoProvider = DSCognitoAuthProvider(
  userPoolId: 'us-east-1_abc123def',
  clientId: 'your-cognito-client-id',
  region: 'us-east-1',
  clientSecret: 'your-client-secret', // Optional
  identityPoolId: 'us-east-1:12345678-1234-1234-1234-123456789012', // Optional
);

// Initialize the provider
await cognitoProvider.initialize({
  'userPoolId': 'us-east-1_abc123def',
  'clientId': 'your-cognito-client-id',
  'region': 'us-east-1',
});

// Register with DartStream
DSAuthManager.registerProvider('cognito', cognitoProvider);
final authManager = DSAuthManager('cognito');
```

### Cognito Usage Examples

#### Basic Authentication Flow

```dart
// Create a new user account
try {
  await authManager.createAccount(
    'user@example.com',
    'SecurePassword123!',
    displayName: 'John Doe',
  );
  print('Account created successfully!');
  
  // Confirm email with verification code
  await cognitoProvider.confirmEmail('user@example.com', '123456');
  print('Email confirmed!');
} catch (e) {
  print('Account creation failed: $e');
}

// Sign in
try {
  await authManager.signIn('user@example.com', 'SecurePassword123!');
  
  final user = await authManager.getCurrentUser();
  print('Welcome ${user.displayName}!');
  print('User ID: ${user.id}');
  print('Email verified: ${user.customAttributes?['email_verified']}');
} catch (e) {
  print('Sign in failed: $e');
}

// Sign out
await authManager.signOut();
print('Signed out successfully');
```

#### Password Management

```dart
// Send password reset email
await cognitoProvider.sendPasswordResetEmail('user@example.com');
print('Password reset email sent');

// Update password (when signed in)
await cognitoProvider.updatePassword('NewSecurePassword123!');
print('Password updated successfully');
```

#### User Profile Management

```dart
// Update user profile
await cognitoProvider.updateProfile(
  displayName: 'John Smith',
  photoURL: 'https://example.com/avatar.jpg',
);

// Update email address
await cognitoProvider.updateEmail('newemail@example.com');

// Update custom user attributes
await cognitoProvider.updateUserAttributes({
  'given_name': 'John',
  'family_name': 'Smith',
  'phone_number': '+1234567890',
  'custom:department': 'Engineering',
});

// Check email verification status
final isEmailVerified = await cognitoProvider.isEmailVerified();
if (!isEmailVerified) {
  await cognitoProvider.sendEmailVerification();
  print('Email verification sent');
}
```

#### Token Management

```dart
// Verify token
final isValid = await authManager.verifyToken();
print('Token is valid: $isValid');

// Refresh token
try {
  final newToken = await authManager.refreshToken('refresh_token_here');
  print('Token refreshed: $newToken');
} catch (e) {
  print('Token refresh failed: $e');
}
```

#### Advanced User Management

```dart
// Get user by ID
final user = await authManager.getUser('cognito|user-id-here');
print('User found: ${user.email}');

// Delete user account
await cognitoProvider.deleteUser();
print('User account deleted');
```

### Cognito Configuration

#### Environment Variables

```bash
# AWS Cognito Configuration
COGNITO_USER_POOL_ID=us-east-1_abc123def
COGNITO_CLIENT_ID=your-cognito-client-id
COGNITO_CLIENT_SECRET=your-client-secret
COGNITO_REGION=us-east-1
COGNITO_IDENTITY_POOL_ID=us-east-1:12345678-1234-1234-1234-123456789012

# Optional: AWS Credentials (if using real AWS services)
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_REGION=us-east-1
```

#### Cognito User Pool Setup

1. **Create User Pool**
   ```bash
   aws cognito-idp create-user-pool \
     --pool-name "dartstream-users" \
     --policies PasswordPolicy='{MinimumLength=8,RequireUppercase=true,RequireLowercase=true,RequireNumbers=true,RequireSymbols=true}' \
     --auto-verified-attributes email \
     --username-attributes email
   ```

2. **Create User Pool Client**
   ```bash
   aws cognito-idp create-user-pool-client \
     --user-pool-id us-east-1_abc123def \
     --client-name "dartstream-client" \
     --generate-secret \
     --explicit-auth-flows ADMIN_NO_SRP_AUTH USER_PASSWORD_AUTH
   ```

3. **Configure Verification**
   ```bash
   aws cognito-idp update-user-pool \
     --user-pool-id us-east-1_abc123def \
     --verification-message-template \
     'EmailMessage="Please verify your email with code {####}",EmailSubject="Verify your email"'
   ```

### Cognito Features

#### Standard Authentication Features
- **User Registration** - Create accounts with email/password
- **User Authentication** - Secure sign-in/sign-out
- **Email Verification** - Confirm user email addresses
- **Password Reset** - Reset forgotten passwords
- **Password Updates** - Change passwords for signed-in users
- **Profile Management** - Update user profiles and attributes
- **User Deletion** - Remove user accounts

#### Token Management
- **JWT Tokens** - Secure JSON Web Token handling
- **Token Validation** - Verify token authenticity and expiration
- **Token Refresh** - Refresh expired access tokens
- **Session Management** - Track user sessions across devices

#### Cognito-Specific Features
- **User Pools** - Scalable user directory service
- **Identity Pools** - Federated identity management (optional)
- **Multi-Factor Authentication** - Enhanced security (configurable)
- **Custom Attributes** - Store additional user data
- **User Groups** - Organize users by roles/permissions
- **Lambda Triggers** - Custom authentication flows
- **Social Providers** - Facebook, Google, Amazon, Apple integration
- **SAML/OIDC** - Enterprise identity provider federation

#### Error Handling
- **Comprehensive Error Mapping** - AWS Cognito errors to DartStream errors
- **Rate Limiting** - Handle AWS API rate limits gracefully
- **Network Resilience** - Retry logic for network failures
- **Validation** - Input validation and sanitization

#### Event System
- **Authentication Events** - Login/logout event hooks
- **User Events** - Account creation, deletion, updates
- **Token Events** - Token refresh and validation events
- **Custom Event Handling** - Extensible event system

### Production Considerations

#### Security Best Practices

```dart
// Enable MFA
await cognitoProvider.enableMFA(
  type: 'SMS', // or 'TOTP'
  phoneNumber: '+1234567890',
);

// Set password policy
await cognitoProvider.updateUserPool({
  'PasswordPolicy': {
    'MinimumLength': 12,
    'RequireUppercase': true,
    'RequireLowercase': true,
    'RequireNumbers': true,
    'RequireSymbols': true,
  }
});

// Configure account lockout
await cognitoProvider.updateUserPool({
  'AccountRecoverySetting': {
    'RecoveryMechanisms': [
      {'Name': 'verified_email', 'Priority': 1},
      {'Name': 'verified_phone_number', 'Priority': 2},
    ]
  }
});
```

#### Monitoring and Analytics

```dart
// Enable detailed logging
DSAuthManager.enableDebugging = true;

// Custom event tracking
cognitoProvider.onLoginSuccess = (user) async {
  // Track successful logins
  analytics.track('user_login', {
    'user_id': user.id,
    'provider': 'cognito',
    'timestamp': DateTime.now().toIso8601String(),
  });
};

cognitoProvider.onLogout = () async {
  // Track user logout
  analytics.track('user_logout', {
    'provider': 'cognito',
    'timestamp': DateTime.now().toIso8601String(),
  });
};
```

#### Environment Setup

```dart
// Development environment
final cognitoProvider = DSCognitoAuthProvider(
  userPoolId: 'us-east-1_dev123',
  clientId: 'dev-client-id',
  region: 'us-east-1',
);

// Production environment
final cognitoProvider = DSCognitoAuthProvider(
  userPoolId: 'us-east-1_prod456',
  clientId: 'prod-client-id',
  region: 'us-east-1',
  clientSecret: Platform.environment['COGNITO_CLIENT_SECRET'],
);
```

---

## Choosing the Right Provider

### Firebase vs Auth0 vs Cognito Comparison

| Feature | Firebase | Auth0 | Cognito | Best For |
|---------|----------|-------|---------|----------|
| **Setup Complexity** | Simple | Moderate | Moderate | Firebase: Quick prototypes<br>Auth0: Enterprise apps<br>Cognito: AWS-integrated apps |
| **Pricing** | Pay-as-you-grow | Tiered pricing | Pay-per-usage | Firebase: Small to medium apps<br>Auth0: Predictable enterprise costs<br>Cognito: AWS ecosystem apps |
| **Customization** | Limited | Extensive | High (Lambda triggers) | Firebase: Standard flows<br>Auth0: Custom authentication<br>Cognito: AWS-native customization |
| **Compliance** | Basic | Advanced (SOC2, HIPAA, etc.) | AWS compliance (SOC, PCI DSS, HIPAA) | Firebase: General use<br>Auth0: Regulated industries<br>Cognito: AWS compliance needs |
| **Social Providers** | Google ecosystem focus | 30+ providers | Major providers + SAML/OIDC | Firebase: Google integration<br>Auth0: Multi-provider<br>Cognito: Enterprise federation |
| **Enterprise Features** | Limited | Comprehensive (SSO, SAML, etc.) | Advanced (User Pools, Identity Pools) | Firebase: Consumer apps<br>Auth0: B2B/Enterprise<br>Cognito: AWS enterprise |
| **Multi-tenant Support** | Manual implementation | Built-in | User Groups + Lambda | Firebase: Single tenant<br>Auth0: Multi-tenant SaaS<br>Cognito: AWS multi-tenant |
| **API Management** | Separate Firebase products | Integrated | AWS API Gateway integration | Firebase: Simple APIs<br>Auth0: Complex API ecosystems<br>Cognito: AWS API ecosystem |
| **Scalability** | High | Very High | Very High (AWS scale) | Firebase: Google scale<br>Auth0: Global scale<br>Cognito: AWS global scale |
| **AWS Integration** | None | Limited | Native | Firebase: Non-AWS apps<br>Auth0: Multi-cloud<br>Cognito: AWS-first applications |

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

### When to Use Cognito

**Choose Cognito when you need:**
- Deep AWS ecosystem integration
- Serverless application architecture
- Cost-effective scaling with AWS pricing
- Lambda-based custom authentication flows
- Identity and access management (IAM) integration
- Federated identity with enterprise providers
- Mobile app authentication with AWS services
- Compliance with AWS security standards
- Integration with AWS API Gateway and other AWS services
- Multi-region deployment capabilities

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

// Or initialize with Cognito
await DSFlutterMobileCore.initialize(
  defaultAuthProvider: 'cognito',
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
